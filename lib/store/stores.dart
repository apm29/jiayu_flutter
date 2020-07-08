import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_scaffold/api/Api.dart';
import 'package:flutter_scaffold/model/BaseResp.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/model/PageData.dart';
import 'package:flutter_scaffold/storage/LocalCache.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/reducers.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

///
/// author : ciih
/// date : 2020/7/6 2:24 PM
/// description :
///
final DevToolsStore<JiaYuState> store = DevToolsStore<JiaYuState>(
  appReducer,
  initialState: JiaYuState(),
  middleware: <Middleware<JiaYuState>>[],
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

class DashboardModel {
  List<MallGoods> goodsList = [];
  bool hasMore = true;
  bool loading = false;
  int total = 0;

  DashboardModel();

  void loadPagedDate(bool refresh, BuildContext context) async {
    if (refresh) {
      this.goodsList = [];
      this.hasMore = true;
      this.loading = false;
      this.total = 0;
    }
    if (!this.loading && this.hasMore) {
      try {
        this.loading = true;
        BaseResp<PageDate<MallGoods>> resp = await Api.getGoodsList();
        if (resp.success) {
          this.goodsList.addAll(resp.data.records);
          this.total = resp.data.total;
          this.hasMore = this.total > this.goodsList.length;
        }
        StoreProvider.of<JiaYuState>(context)
            .dispatch(DashboardLoadCompleteAction());
      } catch (e) {
        print(e);
      } finally {
        this.loading = false;
      }
    }
  }
}
