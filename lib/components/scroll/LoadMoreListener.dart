import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

///
/// author : ciih
/// date : 2020/7/13 3:38 PM
/// description :
///
class LoadMoreListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;

  LoadMoreListener({@required this.child, @required this.onLoadMore});

  @override
  _LoadMoreListenerState createState() => _LoadMoreListenerState();
}

class _LoadMoreListenerState extends State<LoadMoreListener> {
  StreamController<ScrollNotification> _controller = StreamController();

  @override
  void initState() {
    super.initState();
    //事件节流
    _controller.stream
        .throttle((_) => TimerStream(true, Duration(milliseconds: 600)))
        .listen((event) => widget.onLoadMore?.call());
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter <= 0.0) {
          _controller.add(notification);
        }
        return false;
      },
      child: widget.child,
    );
  }
}
