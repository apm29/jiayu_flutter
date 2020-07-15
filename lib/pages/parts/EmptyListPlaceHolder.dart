import 'package:flutter/widgets.dart';

///
/// author : apm29
/// date : 2020/7/15 11:59 AM
/// description :
///
class EmptyListPlaceHolder extends StatelessWidget {
  final String hint;

  const EmptyListPlaceHolder({Key key, this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => Container(
        width: constraint.maxWidth,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 32,
            ),
            Text(
              hint != null ? hint : '暂无数据',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 32,
            ),
            Image.asset(
              'assets/images/no_data.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
