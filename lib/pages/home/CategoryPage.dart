import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/config/Config.dart';
import 'package:jiayu_flutter/model/Category.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/pages/parts/IndexScrollTabView.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores/IndexStore.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<IndexStore>(
      store: indexStore,
      child: Builder(
        builder: (context) => StoreConnector<IndexStore, IndexStore>(
          onInitialBuild: (data) => refresh(context),
          converter: (store) => store.state,
          builder: (context, data) => Scaffold(
            body: Column(
              children: <Widget>[
                IndexScrollTabView(data.categoryList, (index) {
                  data.keyList.forEach((element) {
                    if (element.currentContext != null) {
                      final index = data.keyList.indexOf(element);
                      data.itemHeightList[index] =
                          element.currentContext.size.height;
                    }
                  });
                  final goods = data.goodsList.firstWhere((element) =>
                      element.categoryId[0] == data.categoryList[index].id);
                  final goodsIndex = data.goodsList.indexOf(goods);
                  double offset = 0;
                  for (int i = 0; i < goodsIndex; i++) {
                    offset += data.itemHeightList[i];
                  }
                  data.controller.animateTo(offset,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease);
                }),
                Expanded(
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      data.keyList.forEach((element) {
                        if (element.currentContext != null) {
                          final index = data.keyList.indexOf(element);
                          data.itemHeightList[index] =
                              element.currentContext.size.height;
                        }
                      });
                      int index = 0;
                      double height = 0.0;
                      for (int i = 0; i < data.itemHeightList.length; i++) {
                        if (height >= notification.metrics.pixels) {
                          index = i;
                          break;
                        }
                        height += data.itemHeightList[i];
                      }
                      StoreProvider.of<IndexStore>(context).dispatch(
                          CategoryChangeAction(
                              data.goodsList[index].categoryId));
                      return false;
                    },
                    child: CustomScrollView(
                      controller: data.controller,
                      slivers: <Widget>[
                        CupertinoSliverRefreshControl(
                          refreshTriggerPullDistance: 120,
                          refreshIndicatorExtent: 60,
                          onRefresh: () async {
                            return refresh(context);
                          },
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              key: data.keyList[index],
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 12,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Image.network(Config.FileBaseUrl +
                                      data.goodsList[index].picUrl),
                                  Text(
                                    data.goodsList[index].categoryId.toString(),
                                  ),
                                ],
                              ),
                            ),
                            childCount: data.goodsList.length,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  refresh(BuildContext context) {
    StoreProvider.of<IndexStore>(context)
        .dispatch(CategoryPageLoadAction(context, refresh: true));
  }
}

class CategoryIndexPage extends StatefulWidget {
  @override
  CategoryIndexPageState createState() => CategoryIndexPageState();

  static CategoryIndexPageState of(BuildContext context) {
    return context.findAncestorStateOfType<CategoryIndexPageState>();
  }
}

class CategoryIndexPageState extends State<CategoryIndexPage>
    with SingleTickerProviderStateMixin {
  final categoryList = [
    Category(id: 1, children: [
      Category(id: 2),
      Category(id: 3),
      Category(id: 4),
      Category(id: 5),
    ]),
    Category(id: 11, children: [
      Category(id: 12),
      Category(id: 13),
      Category(id: 14),
      Category(id: 15),
    ]),
    Category(id: 21, children: [
      Category(id: 22),
      Category(id: 23),
      Category(id: 24),
      Category(id: 25),
    ]),
    Category(id: 31, children: [
      Category(id: 32),
      Category(id: 33),
      Category(id: 34),
      Category(id: 35),
    ]),
  ];
  final goodsData = [
    MallGoods(categoryId: [1, 2]),
    MallGoods(categoryId: [1, 2]),
    MallGoods(categoryId: [1, 2]),
    MallGoods(categoryId: [1, 3]),
    MallGoods(categoryId: [1, 3]),
    MallGoods(categoryId: [11, 12]),
    MallGoods(categoryId: [11, 12]),
    MallGoods(categoryId: [11, 13]),
    MallGoods(categoryId: [21, 22]),
    MallGoods(categoryId: [21, 22]),
    MallGoods(categoryId: [21, 24]),
    MallGoods(categoryId: [21, 24]),
    MallGoods(categoryId: [31, 32]),
    MallGoods(categoryId: [31, 32]),
    MallGoods(categoryId: [31, 32]),
    MallGoods(categoryId: [31, 35]),
  ];

  IndexController _animationController;
  IndexListController _indexListController = IndexListController();

  List<GlobalObjectKey> get tabKeys =>
      categoryList.map((e) => GlobalObjectKey(e)).toList();

  List<GlobalObjectKey> get goodsKeys =>
      goodsData.map((e) => GlobalObjectKey(e)).toList();

  @override
  void initState() {
    super.initState();
    _animationController = IndexController(
      0,
      0,
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }

  TickerFuture changeIndex(int index) {
    return _animationController.changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => Row(
        children: <Widget>[
          SafeArea(
            child: CustomPaint(
              foregroundPainter: _IndicatorPainter(
                tabKeys: tabKeys,
                controller: _animationController,
              ),
              child: SizedBox(
                width: 100,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (ctx, index) => Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () async {
                        CategoryIndexPage.of(context).changeIndex(index);
                        var categoryId = (tabKeys[index].value as Category).id;
                        double sum = 0;
                        for (int i = 0; i < goodsKeys.length; i++) {
                          if ((goodsKeys[i].value as MallGoods).categoryId[0] !=
                              categoryId) {
                            var other =
                                goodsKeys[i].currentContext?.size?.height ?? 0;
                            sum += other;
                            if (i + 1 < goodsKeys.length &&
                                goodsKeys[i + 1].currentContext?.size == null) {
                              await _indexListController.animateTo(
                                sum,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          } else {
                            var other =
                                goodsKeys[i].currentContext?.size?.height ?? 0;
                            sum += other;
                            break;
                          }
                        }
                        await _indexListController.animateTo(
                          sum,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        color: Colors.white,
                        child: Text(categoryList[index].id.toString()),
                        key: tabKeys[index],
                      ),
                    ),
                  ),
                  itemCount: categoryList.length,
                ),
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              double offset = notification.metrics.pixels;
              double sum = 0;
              int categoryId = 0;
              for (int i = 0; i < goodsKeys.length; i++) {
                sum += goodsKeys[i].currentContext.size.height;
                if (sum >= offset) {
                  categoryId = (goodsKeys[i].value as MallGoods).categoryId[0];
                  break;
                }
              }
              _animationController.changeIndex(
                  categoryList.map((e) => e.id).toList().indexOf(categoryId));
              return false;
            },
            child: Expanded(
              child: CustomScrollView(
                controller: _indexListController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(goodsData
                        .map((e) => Container(
                              key: goodsKeys[goodsData.indexOf(e)],
                              padding: EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 10),
                              color: Colors.white70,
                              child: Text(goodsData[goodsData.indexOf(e)]
                                  .categoryId
                                  .toString()),
                            ))
                        .toList()),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IndexController extends AnimationController {
  int previousIndex;
  int currentIndex;

  IndexController(this.previousIndex, this.currentIndex,
      {Duration duration, TickerProvider vsync})
      : super(duration: duration, vsync: vsync);

  double get percent => (value - lowerBound) == 0
      ? 0
      : (value - lowerBound) / (upperBound - lowerBound);

  TickerFuture changeIndex(int index) {
    if (currentIndex == index) {
      return TickerFuture.complete();
    }
    previousIndex = currentIndex;
    currentIndex = index;
    this.reset();
    return this.forward();
  }
}

class IndexListController extends ScrollController {}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({this.tabKeys, this.controller})
      : super(repaint: controller);

  final List<GlobalObjectKey> tabKeys;
  final IndexController controller;

  Paint painter = Paint()..color = Colors.amber.withAlpha(122);

  int get currentIndex => controller.currentIndex;

  int get previousIndex => controller.previousIndex;

  @override
  void paint(Canvas canvas, Size size) {
    Size previousIndicatorSize = tabKeys[previousIndex].currentContext.size;
    Size currentIndicatorSize = tabKeys[currentIndex].currentContext.size;
    SizeTween sizeTween = SizeTween(
      begin: previousIndicatorSize,
      end: currentIndicatorSize,
    );
    Tween<double> topTween = Tween(
        begin: previousIndex == 0
            ? 0
            : tabKeys
                .sublist(0, previousIndex)
                .map((e) => e.currentContext.size.height)
                .reduce((value, element) => value + element),
        end: currentIndex == 0
            ? 0
            : tabKeys
                .sublist(0, currentIndex)
                .map((e) => e.currentContext.size.height)
                .reduce((value, element) => value + element));
    double percent = Curves.ease.transform(controller.percent).clamp(0, 1.0);
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        topTween.transform(percent),
        sizeTween.transform(percent).width,
        sizeTween.transform(percent).height,
      ),
      painter,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return tabKeys.length != old.tabKeys.length;
  }
}
