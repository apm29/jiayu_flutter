import 'package:flutter/material.dart';
import 'package:flutter_scaffold/utils/utils.dart';

///
/// author : ciih
/// date : 2020/7/8 1:58 PM
/// description : 
///
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('CategoryPage'),
          ),
          RaisedButton(
            onPressed: ()=>showAppToast("Hello "*10),
            child: Text('Toast Message'),
          ),
          RaisedButton(
            onPressed: ()=>showAppToast("Hello "*5,type: ToastType.Alert),
            child: Text('Toast Alert'),
          ),
          RaisedButton(
            onPressed: ()=>showAppToast("Hello "*7,type: ToastType.Info),
            child: Text('Toast Info'),
          ),
          RaisedButton(
            onPressed: ()=>showAppToast("Hello "*7,type: ToastType.Warning),
            child: Text('Toast Warning'),
          ),
          Switch(value: false, onChanged: (v)=>{})
        ],
      ),
    );
  }
}
