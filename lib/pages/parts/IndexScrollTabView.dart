import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/model/Category.dart';
import 'package:jiayu_flutter/store/stores/IndexStore.dart';

///
/// author : ciih
/// date : 2020/7/17 1:14 PM
/// description :
///
class IndexScrollTabView extends StatefulWidget {
  final List<Category> data;

  final ValueChanged<int> onTap;
  IndexScrollTabView(this.data, this.onTap);
  @override
  _IndexScrollTabViewState createState() => _IndexScrollTabViewState();
}

class _IndexScrollTabViewState extends State<IndexScrollTabView>
    with TickerProviderStateMixin {
  TabController  _tabController;


  @override
  void initState() {
    super.initState();
    var store = StoreProvider.of<IndexStore>(context, listen: false).state;
    store.addListener(() {
      int index = this.widget.data.indexOf(
        this.widget.data.firstWhere((element) => element.id == store.category[0])
      );
      _tabController.animateTo(index);
    });
  }

  @override
  void dispose() {
    var store = StoreProvider.of<IndexStore>(context, listen: false).state;
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: widget.data.length, vsync: this);
    return SafeArea(
      child: TabBar(
        tabs: widget.data.map((e) => buildItem(e)).toList(),
        controller: _tabController,
        onTap: widget.onTap,
        indicatorWeight: 4.0,
      ),
    );
  }

  Widget buildItem(Category e) => Container(
        child: Column(
          children: <Widget>[
            Text(e.name),
            Text(e.id.toString()),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      );
}
