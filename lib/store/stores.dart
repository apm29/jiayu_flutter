import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiayu_flutter/storage/LocalCache.dart';
import 'package:jiayu_flutter/store/middlewares.dart';
import 'package:jiayu_flutter/store/reducers.dart';
import 'package:jiayu_flutter/store/stores/CategoryModel.dart';
import 'package:jiayu_flutter/store/stores/DashBoardModel.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

///
/// author : apm29
/// date : 2020/7/6 2:24 PM
/// description :
///
final DevToolsStore<JiaYuState> appStore = DevToolsStore<JiaYuState>(
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
  CategoryModel categoryModel = CategoryModel();

  JiaYuState()
      : this.locale =
            Locale.fromSubtags(languageCode: LocalCache().locale ?? 'en');
}

enum ListState { Loading, NoMore, HasMore }
