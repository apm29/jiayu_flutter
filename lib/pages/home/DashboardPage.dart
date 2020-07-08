import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores.dart';

///
/// author : ciih
/// date : 2020/7/8 1:58 PM
/// description :
///
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<JiaYuState, List<MallGoods>>(
      converter: (store) => store.state.dashboardModel.goodsList,
      onInit: (store) {
        store.dispatch(DashboardLoadAction(context, refresh: true));
      },
      builder: (context, data) => GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: <Widget>[...data.map((e) => Text(e.name)).toList()],
      ),
    );
  }
}
