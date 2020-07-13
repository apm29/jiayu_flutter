import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scaffold/api/Api.dart';
import 'package:flutter_scaffold/components/modal/TaskModal.dart';
import 'package:flutter_scaffold/model/BaseResp.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/model/PageData.dart';
import 'package:flutter_scaffold/storage/LocalCache.dart';
import 'package:flutter_scaffold/store/middlewares.dart';
import 'package:flutter_scaffold/store/reducers.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

///
/// author : ciih
/// date : 2020/7/6 2:24 PM
/// description :
///
final DevToolsStore<JiaYuState> store = DevToolsStore<JiaYuState>(
  appReducer,
  initialState: JiaYuState(),
  middleware: createAppMiddleware(),
);

class JiaYuState {
  int count = 0;
  Locale locale;

  int homePageIndex = 0;
  bool hideHomeNavigationBar = false;

  int loading = 0;

  DashboardModel dashboardModel = DashboardModel();

  JiaYuState() : this.locale = Locale(LocalCache().locale ?? 'zh');
}

enum ListState { Loading, NoMore, HasMore }

class DashboardModel {
  List<MallGoods> goodsList = [];
  bool hasMore = true;
  bool loading = false;
  int _total = 0;
  int _page = 1;
  int _rows = 2;

  ListState get listState => getListState(hasMore, loading);

  getListState(bool hasMore, bool loading) {
    if (loading) {
      return ListState.Loading;
    } else if (hasMore) {
      return ListState.HasMore;
    } else {
      return ListState.NoMore;
    }
  }

  DashboardModel();


  Future<void> loadPagedData(bool refresh,BuildContext context) async {
    if (refresh) {
      this.goodsList = [];
      this.hasMore = true;
      this.loading = false;
      this._total = 0;
      this._page = 1;
    }
    if (!this.loading && this.hasMore) {
      await TaskModal.runTask(context, () async {
        try {
          this.loading = true;
          BaseResp<PageData<MallGoods>> resp = await Api.getGoodsList({
            "pageNo": this._page,
            "pageSize": this._rows,
          });
          if (resp.success) {
            this.goodsList.addAll(resp.data.records);
            this._total = resp.data.total;
            this.hasMore = this._total > this.goodsList.length;
            this._page += 1;
          }
        } catch (e) {
          print(e);
        } finally {
          this.loading = false;
        }
      });
    }
  }
}
