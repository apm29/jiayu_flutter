import 'package:flutter/material.dart';
import 'package:jiayu_flutter/pages/style/styles.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [mainColor, Colors.white.withAlpha(0x77)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                  ),
                  height: 200,
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 12,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.grey[400],
                                child: Icon(
                                  Icons.person_outline,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(child: Text('未登录'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('我的收藏'),
              subtitle: Text('个人收藏的产品在这里'),
            ),
            ListTile(
              leading: Icon(Icons.face),
              title: Text('咨询客服'),
              subtitle: Text('在线询问价格'),
            ),
            // ListTiles++
          ]),
        ),
      ],
    );
  }
}
