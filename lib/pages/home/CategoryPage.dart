import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/components/scroll/LoadMoreListener.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/pages/parts/GoodsListItem.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores/IndexStore.dart';
import 'package:redux/redux.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();

final ItemScrollController indexScrollController = ItemScrollController();
final ItemPositionsListener indexPositionsListener =
    ItemPositionsListener.create();

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoreProvider<IndexStore>(
        store: indexStore,
        child: Builder(
          builder: (context) => StoreBuilder<IndexStore>(
            onInitialBuild: (store) => refresh(context),
            builder: (context, vm) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100),
                  child: vm.state.categoryList.isEmpty
                      ? Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : ScrollablePositionedList.builder(
                          initialScrollIndex: 3,
                          itemScrollController: indexScrollController,
                          itemPositionsListener: indexPositionsListener,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (ctx, index) => Builder(
                            builder: (ctx) => GestureDetector(
                              onTap: () async {
                                await changeIndexCategory(vm, index, context);
                              },
                              child: buildCategoryItem(vm, index),
                            ),
                          ),
                          itemCount: vm.state.categoryList.length,
                        ),
                ),
                Expanded(
                  child: vm.state.goodsList.isEmpty
                      ? Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : LoadMoreListener(
                          onLoadMore: () {
                            loadMore(context);
                          },
                          onNotification: (notification) {
                            if (itemPositionsListener
                                    .itemPositions.value.length >
                                0) {
                              var position = itemPositionsListener
                                  .itemPositions.value
                                  .reduce((value, element) =>
                                      value.index < element.index
                                          ? value
                                          : element);
                              List<int> categoryId =
                                  vm.state.goodsList[position.index].categoryId;
                              changeCategory(context, categoryId);
                            }
                            return false;
                          },
                          child: ScrollablePositionedList.builder(
                            itemCount: vm.state.goodsList.length,
                            itemBuilder: (context, index) {
                              return GoodsListItem(
                                goods: vm.state.goodsList[index],
                              );
                            },
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(Store<IndexStore> vm, int index) {
    return Row(
      children: <Widget>[
        isCurrentCategory(vm, index)
            ? Container(
                color: Colors.amber,
                width: 5,
                height: (48 + 16 * 1.1).toDouble(),
              )
            : Container(
                width: 0,
              ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            color:
                isCurrentCategory(vm, index) ? Colors.white : Colors.grey[200],
            child: Text(
              vm.state.categoryList[index].name.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.1),
            ),
          ),
        ),
      ],
    );
  }

  Future changeIndexCategory(
      Store<IndexStore> vm, int index, BuildContext context) async {
    int categoryId = vm.state.categoryList[index].id;
    MallGoods mallGoods = vm.state.goodsList
        .firstWhere((element) => element.categoryId[0] == categoryId);
    if (mallGoods != null) {
      int goodsIndex = vm.state.goodsList.indexOf(mallGoods);
      itemScrollController.scrollTo(
          index: goodsIndex, duration: Duration(milliseconds: 500));
    } else {
      await loadMore(context);
    }
  }

  bool isCurrentCategory(Store<IndexStore> vm, int index) {
    return vm.state.category[0] == vm.state.categoryList[index].id;
  }

  refresh(BuildContext context) {
    StoreProvider.of<IndexStore>(context, listen: false)
        .dispatch(CategoryPageLoadAction(context, refresh: true));
  }

  loadMore(BuildContext context) {
    return StoreProvider.of<IndexStore>(context, listen: false)
        .dispatch(CategoryPageLoadAction(context, refresh: false));
  }

  changeCategory(BuildContext context, List<int> categoryId) {
    return StoreProvider.of<IndexStore>(context, listen: false)
        .dispatch(CategoryChangeAction(categoryId));
  }
}

