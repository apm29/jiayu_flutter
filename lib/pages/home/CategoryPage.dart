import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/config/Config.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/model/Category.dart';
import 'package:jiayu_flutter/pages/parts/IndexScrollTabView.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores.dart';
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
