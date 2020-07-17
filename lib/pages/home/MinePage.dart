import 'package:flutter/material.dart';
import 'package:jiayu_flutter/components/scroll/draggable_upper_drawer.dart';

///
/// author : apm29
/// date : 2020/7/8 1:58 PM
/// description :
///
class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: DraggableUpperDrawerWidget());
  }
}
