import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/components/scroll/LoadMoreListener.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/pages/parts/EmptyListPlaceHolder.dart';
import 'package:jiayu_flutter/pages/parts/GoodsListItem.dart';
import 'package:jiayu_flutter/pages/parts/ListFooterWidget.dart';
import 'package:jiayu_flutter/pages/parts/HomeAppbarDelegate.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
            SliverPersistentHeader(
              delegate: HomeAppbarDelegate(),
              pinned: true,
            ),

            data == null || data.length == 0
                ? SliverToBoxAdapter(
                    child: EmptyListPlaceHolder(
                      hint: '暂无商品',
                    ),
                  )
                : SliverStaggeredGrid.count(
                    crossAxisCount: calculateBestCount(MediaQuery.of(context).size.width),
                    children: data.map((e) => GoodsListItem(goods: e)).toList(),
                    staggeredTiles:
                        data.map((e) => StaggeredTile.fit(1)).toList(),
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

  ///
  /// 计算最优的Item宽度，整数个Item刚好充满maxWidth，并且宽度在180-285之间
  ///
  int calculateBestCount(double maxWidth) {
    double minWidth = 180;
    double maxWidth = 285;
    for (int i in Iterable.generate(10, (index) => index)) {
      var dividedWidth =  maxWidth / i;
      if (minWidth < dividedWidth && dividedWidth < maxWidth) {
        return i;
      }
    }
    return 2;
  }
}
