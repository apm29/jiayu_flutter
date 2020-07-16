import 'package:flutter/widgets.dart';

///
/// author : apm29
/// date : 2020/7/8 1:41 PM
/// description :
///

class AddAction {}

class AppInitAction {
  BuildContext context;

  AppInitAction(this.context);
}

class LoadingAction {
  bool increase;
  LoadingAction(this.increase);
}


class DashboardLoadAction {
  BuildContext context;
  bool refresh;

  DashboardLoadAction(this.context, {this.refresh: false});
}

class CategoryPageLoadAction {
  BuildContext context;
  bool refresh;

  CategoryPageLoadAction(this.context, {this.refresh: false});
}

class HomeIndexSwitchAction {
  BuildContext context;
  int index;

  HomeIndexSwitchAction(this.index, this.context);
}


typedef AsyncResultTask<T> = Future<T> Function();
typedef AsyncTask<T, R> = Future<T> Function(R);
typedef AsyncVoidTask = Future<void> Function();

abstract class VoidTaskAction {
  final AsyncVoidTask task;
  final BuildContext context;
  bool showMask = true;

  VoidTaskAction(this.task, this.context);
}

typedef CheckResult<T> = bool Function(T);

abstract class ResultTaskAction<T> {
  final AsyncResultTask<T> task;
  final BuildContext context;
  T result;

  // intercept action when return false
  CheckResult<T> checker;

  ResultTaskAction(this.task, this.context, {this.checker});
}