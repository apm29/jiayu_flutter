import 'package:flutter/material.dart';
import 'package:jiayu_flutter/store/stores.dart';

///
/// author : apm29
/// date : 2020/7/15 10:49 AM
/// description :
///
typedef ContextCallBack = void Function(BuildContext context);

class ListFooterWidget extends StatelessWidget {
  final ListState state;
  final ContextCallBack onLoadMore;

  const ListFooterWidget({Key key, this.state, this.onLoadMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: state == ListState.Loading
          ? Center(child: CircularProgressIndicator())
          : state == ListState.NoMore
              ? Text(
                  '没有更多了',
                  textAlign: TextAlign.center,
                )
              : FlatButton(
                  onPressed: () => onLoadMore(context),
                  child: Text(
                    '点击加载更多',
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
