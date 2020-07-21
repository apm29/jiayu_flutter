import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// @author apm29
/// 弹出loading页面，完成task后pop（task的result）
///
class TaskModal<T> extends ModalRoute<T> {
  /// use [AsyncVoidTask] or [AsyncResultTask]
  final Function task;
  final minimumLoadingTime = 800;
  final dynamic tag;

  TaskModal(this.task, {this.tag})
      : super(settings: RouteSettings(name: tag));

  @override
  Color get barrierColor => const Color(0x66333333);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => "Loading...";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(),
          Text(tag?.toString() ?? "")
        ],
      ),
    );
  }

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  void install() {
    () async {
      int start = DateTime.now().millisecondsSinceEpoch;
      T result;
      try {
        result = await task?.call();
      } finally {
        int end = DateTime.now().millisecondsSinceEpoch;
        if ((end - start) < minimumLoadingTime) {
          await Future.delayed(
              Duration(milliseconds: minimumLoadingTime - (end - start)));
        }
        Navigator.of(taskPool[task]).pop(result);
        taskPool.remove(task);
      }
    }();
    super.install();
  }

  static Map<Function,BuildContext> taskPool = Map();


  static Future runTask(BuildContext context, Function task, {dynamic tag}) {
    taskPool[task] = context;
    return Navigator.of(context).push(TaskModal(task, tag: tag));
  }
}

