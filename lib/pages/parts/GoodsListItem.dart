import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayu_flutter/components/scroll/ImagePlaceholder.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/pages/parts/GoodsItemTagsWidget.dart';
import 'package:jiayu_flutter/pages/style/styles.dart';

///
/// author : apm29
/// date : 2020/7/14 5:08 PM
/// description :
///
class GoodsListItem extends StatelessWidget {
  final MallGoods goods;
  final _kCardRadius = 3.0;
  const GoodsListItem({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(2, 12),
                  blurRadius: 10,
                )
              ],
              color: Colors.white
            ),
            margin: EdgeInsets.only(bottom: 22),
            clipBehavior: Clip.antiAlias,
            child: GoodsItemTagsWidget(
              isHot: goods.isHot,
              isNew: goods.isNew,
              isOnSale: goods.isOnSale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImagePlaceholder(
                    src: goods.picUrl,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          goods.name,
                          style: goodsTitleStyle,
                        ),
                        SizedBox(
                          height: goodsBriefStyle.height *
                              goodsBriefStyle.fontSize *
                              2,
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
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
