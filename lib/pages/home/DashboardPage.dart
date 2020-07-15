import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_scaffold/components/scroll/LoadMoreListener.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/pages/parts/EmptyListPlaceHolder.dart';
import 'package:flutter_scaffold/pages/parts/GoodsListItem.dart';
import 'package:flutter_scaffold/pages/parts/ListFooterWidget.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<JiaYuState, List<MallGoods>>(
      converter: (store) => store.state.dashboardModel.goodsList,
      onInitialBuild: (store) {
        refresh(context);
      },
      builder: (context, data) => LoadMoreListener(
        onLoadMore: () {
          loadMore(context);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 120,
              refreshIndicatorExtent: 60,
              onRefresh: () async {
                return refresh(context);
              },
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: data == null || data.isEmpty
                    ? [
                        EmptyListPlaceHolder(
                          hint: '暂无商品',
                        )
                      ]
                    : data.map((e) => GoodsListItem(goods: e)).toList(),
              ),
            ),
            StoreConnector<JiaYuState, ListState>(
              converter: (store) => store.state.dashboardModel.listState,
              builder: (context, state) => SliverToBoxAdapter(
                child: ListFooterWidget(
                  state: state,
                  onLoadMore: loadMore,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refresh(BuildContext context) {
    return StoreProvider.of<JiaYuState>(context)
        .dispatch(DashboardLoadAction(context, refresh: true));
  }

  Future<void> loadMore(BuildContext context) {
    return StoreProvider.of<JiaYuState>(context)
        .dispatch(DashboardLoadAction(context, refresh: false));
  }
}
