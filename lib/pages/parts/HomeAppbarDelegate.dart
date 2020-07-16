import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scaffold/generated/l10n.dart';

///
/// author : apm29
/// date : 2020/7/16 2:40 PM
/// description :
///
class HomeAppbarDelegate extends SliverPersistentHeaderDelegate {
  final iconSize = 32.0;
  final titleFontSize = 32.0;
  final iconPadding = 6.0;
  final _kCardRadius = 8.0;
  final _kSearchBarShadowBlur = 10.0;
  final _kSearchBarShadowOffsetY = 12.0;
  final _kSearchBarMarginTop = 8.0;
  final searchBarColor = Colors.grey[400];
  double get _kSearchBarMarginBottom =>
      _kSearchBarShadowBlur + _kSearchBarShadowOffsetY;


  @override
  double get maxExtent => 144;

  @override
  double get minExtent => 78;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double systemPadding = MediaQuery.of(context).padding.top;
    double percent = shrinkOffset / (maxExtent - minExtent);
    percent = percent.clamp(0.0, 1.0);
    double easeInExpoPercent = Curves.easeInExpo.transform(percent);
    Tween<double> titleTopTween = Tween(
      begin: systemPadding + (minExtent-systemPadding-titleFontSize)/2,
      end: -titleFontSize,
    );
    Tween<double> titleFontTween = Tween(
      begin: titleFontSize,
      end: titleFontSize / 2,
    );
    Tween<double> searchTopTween = Tween(
      begin: minExtent,
      end: systemPadding,
    );
    Tween<double> searchHorizontalTween = Tween(
      begin: iconPadding,
      end: iconPadding * 2 + iconSize,
    );
    Tween<double> searchTopMarginTween = Tween(
      begin: 0,
      end: _kSearchBarMarginTop,
    );
    Tween<double> searchShadowOffsetTween = Tween(
      begin: _kSearchBarShadowOffsetY,
      end: 0,
    );
    Tween<double> searchShadowBlurTween = Tween(
      begin: _kSearchBarShadowBlur,
      end: 0,
    );
    Tween<double> searchHeightTween = Tween(
      begin: maxExtent -
          minExtent -
          _kSearchBarMarginBottom ,
      end: minExtent - systemPadding - 2 * _kSearchBarMarginTop,
    );
    ColorTween searchBorderColorTween = ColorTween(
      begin: Colors.grey[600],
      end: Colors.transparent,
    );
    Tween<double> elevationTween = Tween(
      begin: 0,
      end: 12,
    );

    return Material(
      elevation: elevationTween.transform(easeInExpoPercent),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: (minExtent - systemPadding - iconSize) / 2 + systemPadding,
            left: iconPadding,
            child: Icon(
              Icons.menu,
              size: iconSize,
              color: Colors.grey[600],
            ),
          ),
          Positioned(
            top: (minExtent - systemPadding - iconSize) / 2 + systemPadding,
            right: iconPadding,
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: CircleAvatar(
                backgroundColor: Colors.grey[400],
                child: Icon(
                  Icons.person_outline,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: titleTopTween.transform(percent),
            left: iconPadding + iconSize,
            right: iconPadding + iconSize,
            child: Text(
              S.of(context).appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: titleFontTween.transform(easeInExpoPercent)),
            ),
          ),
          Positioned(
            top: searchTopTween.transform(percent),
            left: searchHorizontalTween.transform(percent),
            right: searchHorizontalTween.transform(percent),
            child: Container(
              height: searchHeightTween.transform(percent),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
                  border: Border.all(
                    color: searchBorderColorTween.transform(percent),
                    width: 0.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: searchBarColor,
                      offset:
                          Offset(0, searchShadowOffsetTween.transform(percent)),
                      blurRadius: searchShadowBlurTween.transform(percent),
                    )
                  ],
                  color: Colors.white),
              margin: EdgeInsets.only(
                bottom: _kSearchBarMarginBottom,
                top: searchTopMarginTween.transform(percent),
              ),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'search',
                      style: TextStyle(color: searchBarColor),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: searchBarColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }



  @override
  bool shouldRebuild(HomeAppbarDelegate oldDelegate) {
    return false;
  }

  @override
  OverScrollHeaderStretchConfiguration stretchConfiguration;
}
