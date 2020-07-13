import 'package:flutter/widgets.dart';
import 'package:flutter_scaffold/components/modal/TaskModal.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores.dart';
import 'package:oktoast/oktoast.dart';
import 'package:redux/redux.dart';

///
/// author : ciih
/// date : 2020/7/8 1:44 PM
/// description :
///
List<Middleware<JiaYuState>> createAppMiddleware() {
  return [
    TypedMiddleware<JiaYuState, AppInitAction>(initApp),
    TypedMiddleware<JiaYuState, DashboardLoadAction>(loadDashBoard),
    TypedMiddleware<JiaYuState, VoidTaskAction>(checkVoidTask),
    TypedMiddleware<JiaYuState, ResultTaskAction>(checkResultTask),
  ];
}

initApp(Store<JiaYuState> store, action, NextDispatcher next) {}

loadDashBoard(
    Store<JiaYuState> store, DashboardLoadAction action, NextDispatcher next) {
  return () async {
    print(action);
    bool loaded = await TaskModal.runTask(action.context, () async {
      return await store.state.dashboardModel.loadPagedData(action.refresh);
    });
    print(loaded);
    //await store.state.dashboardModel.loadPagedData(action.refresh);
    if(loaded) {
      next(action);
    }
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
