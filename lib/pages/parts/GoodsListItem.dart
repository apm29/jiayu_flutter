import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scaffold/config/Config.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/pages/parts/GoodsItemTagsWidget.dart';
import 'package:flutter_scaffold/pages/style/styles.dart';

///
/// author : apm29
/// date : 2020/7/14 5:08 PM
/// description :
///
class GoodsListItem extends StatelessWidget {
  final MallGoods goods;

  const GoodsListItem({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraint) => Container(
          constraints: BoxConstraints(
            maxWidth: calculateBestWidth(constraint),
          ),
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            clipBehavior: Clip.antiAlias,
            child: GoodsItemTagsWidget(
              isHot: goods.isHot,
              isNew: goods.isNew,
              isOnSale: goods.isOnSale,
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
                  Text(
                    goods.name,
                    style: goodsTitleStyle,
                  ),
                  SizedBox(
                    height: goodsBriefStyle.height * goodsBriefStyle.fontSize * 2,
                    child: Text(
                      goods.brief,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: goodsBriefStyle.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .color
                            .withAlpha(166),
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '¥',
                      style: goodsPriceStyle,
                      children: [
                        TextSpan(
                          text: goods.retailPrice.toString(),
                          style: goodsPriceStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 计算最优的Item宽度，整数个Item刚好充满maxWidth，并且宽度在180-285之间
  ///
  double calculateBestWidth(BoxConstraints constraint) {
    double minWidth = 180;
    double maxWidth = 285;
    for (int i in Iterable.generate(10, (index) => index)) {
      var dividedWidth = constraint.maxWidth / i;
      if (minWidth < dividedWidth && dividedWidth < maxWidth) {
        return dividedWidth;
      }
    }
    return constraint.maxWidth > 600 ? 300 : constraint.maxWidth * 0.5;
  }
}
