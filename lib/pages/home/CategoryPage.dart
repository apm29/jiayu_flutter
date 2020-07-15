import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_scaffold/model/Category.dart';
import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<JiaYuState, List<Category>>(
      onInitialBuild: (data) => refresh(context),
      converter: (store) => store.state.categoryModel.categoryList,
      builder: (context, data) => CustomScrollView(slivers: [
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 120,
          refreshIndicatorExtent: 60,
          onRefresh: () async {
            return refresh(context);
          },
        ),
        SliverToBoxAdapter(child: Container()),
      ]),
    );
  }

  refresh(BuildContext context) {
    StoreProvider.of<JiaYuState>(context)
        .dispatch(CategoryPageLoadAction(context, refresh: true));
  }
}
