import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

///
/// author : apm29
/// date : 2020/7/13 3:38 PM
/// description : 滑动到底部触发LoadMore
///
class LoadMoreListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final NotificationListenerCallback<ScrollNotification> onNotification;

  LoadMoreListener(
      {@required this.child, @required this.onLoadMore, this.onNotification});

  @override
  _LoadMoreListenerState createState() => _LoadMoreListenerState();
}

class _LoadMoreListenerState extends State<LoadMoreListener> {
  StreamController<ScrollNotification> _controller = StreamController();

  @override
  void initState() {
    super.initState();
    _controller.stream
        .debounceTime(Duration(milliseconds: 50))
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
        return widget.onNotification?.call(notification) ?? false;
      },
      child: widget.child,
    );
  }
}
