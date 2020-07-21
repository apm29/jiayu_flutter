import 'package:flutter/widgets.dart';
import 'package:jiayu_flutter/components/modal/TaskModal.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores.dart';
import 'package:redux/redux.dart';

///
/// author : apm29
/// date : 2020/7/8 1:44 PM
/// description :
///
List<Middleware<JiaYuState>> createAppMiddleware() {
  return [
    TypedMiddleware<JiaYuState, AppInitAction>(initApp),
    TypedMiddleware<JiaYuState, DashboardLoadAction>(loadDashBoard),
    TypedMiddleware<JiaYuState, CategoryPageLoadAction>(loadCategoryPage),
    TypedMiddleware<JiaYuState, VoidTaskAction>(checkVoidTask),
    TypedMiddleware<JiaYuState, ResultTaskAction>(checkResultTask),
  ];
}

initApp(Store<JiaYuState> store, action, NextDispatcher next) {}

loadDashBoard(
    Store<JiaYuState> store, DashboardLoadAction action, NextDispatcher next) {
  return () async {
    await store.state.dashboardModel.loadPagedData(action.refresh,action.context);
    next(action);
  }();
}

loadCategoryPage(
    Store<JiaYuState> store, CategoryPageLoadAction action, NextDispatcher next) {
  return () async {
    await store.state.categoryModel.loadCategoryData(action.context);
    next(action);
  }();
}

checkVoidTask(
    Store<JiaYuState> store, VoidTaskAction action, NextDispatcher next) {
  () async {
    if (action.showMask) {
      await Navigator.of(action.context).push(TaskModal(action.task));
    } else {
      await action.task();
    }
    next(action);
  }();
}

checkResultTask(
    Store<JiaYuState> store, ResultTaskAction action, NextDispatcher next) {
  () async {
    dynamic result =
        await Navigator.of(action.context).push(TaskModal(action.task));
    if (action.checker(result)) {
      action.result = result;
      next(action);
    }
  }();
}
