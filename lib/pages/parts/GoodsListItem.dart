import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scaffold/config/Config.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';

///
/// author : ciih
/// date : 2020/7/14 5:08 PM
/// description :
///
class GoodsListItem extends StatelessWidget {
  final MallGoods goods;

  const GoodsListItem({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(goods);
    return LayoutBuilder(
      builder: (context, constraint) => Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width > 600
                ? 300
                : MediaQuery.of(context).size.width * 0.5),
        padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.618,
              child: Image.network(
                Config.FileBaseUrl + goods.picUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(goods.name),
            Text(goods.brief,maxLines: 2,overflow: TextOverflow.ellipsis,),
            Text.rich(TextSpan(text: '¥',children: [
              TextSpan(text: goods.retailPrice.toString())
            ]),)
          ],
        ),
      ),
    );
  }
}
