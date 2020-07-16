import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// author : apm29
/// date : 2020/7/15 11:31 AM
/// description : 货品左上角和中心下架标签
///
class GoodsItemTagsWidget extends StatelessWidget {
  final Widget child;
  final bool isHot;
  final bool isNew;
  final bool isOnSale;
  final _kCardRadius = 3.0;
  const GoodsItemTagsWidget(
      {Key key, this.isHot, this.isNew, this.isOnSale, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        child,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_kCardRadius),
                bottomRight: Radius.circular(_kCardRadius),
              ),
              color: Color.fromARGB(0xff, 0xC4, 0xA4, 0x55)),
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                child: Text(
                  '热卖',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                offstage: !this.isHot,
              ),
              Offstage(
                child: Container(
                  margin: EdgeInsets.only(left: 3),
                  child: Text(
                    '新品',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                offstage: !this.isNew,
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Offstage(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: Text(
                    '已下架',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            offstage: this.isOnSale,
          ),
        )
      ],
    );
  }
}
