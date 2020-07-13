import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_scaffold/components/AutoSlideDownWidget.dart';
import 'package:flutter_scaffold/components/scroll/LoadMoreListener.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores.dart';

///
/// author : ciih
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
      builder: (context, data) => RefreshIndicator(
        onRefresh: () async {
          return refresh(context);
        },
        child: LoadMoreListener(
          onLoadMore: () {
            loadMore(context);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Text(data[index].name);
                  },
                  childCount: data.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.618,
                ),
              ),
              StoreConnector<JiaYuState, ListState>(
                converter: (store) => store.state.dashboardModel.listState,
                builder: (context, state) => SliverToBoxAdapter(
                  child: state == ListState.Loading
                      ? Center(child: CircularProgressIndicator())
                      : state == ListState.NoMore
                          ? Text(
                              '没有更多了',
                              textAlign: TextAlign.center,
                            )
                          : FlatButton(
                              onPressed: () => loadMore(context),
                              child: Text(
                                '点击加载更多',
                                textAlign: TextAlign.center,
                              ),
                            ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  color: Colors.orangeAccent,
                ),
              )
            ],
          ),
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
