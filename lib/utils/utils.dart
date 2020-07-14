///
/// author : ciih
/// date : 2020/7/14 3:44 PM
/// description :
///
import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oktoast/oktoast.dart';

///
/// author : ciih
/// date : 2020-01-15 09:28
/// description :
///
///
enum ToastType { Message, Alert, Warning, Info }

class NotFoundException implements Exception {
  NotFoundException([this.message]);

  final String message;

  @override
  String toString() => 'NotFoundException($message)';
}

///
/// @param type
/// @param dismissible
///
showAppToast(
  String text, {
  ToastType type: ToastType.Message,
  bool dismissible: true,
}) {
  VoidCallback onPressed = () {
    dismissAllToast(showAnim: true);
  };
  return showToastWidget(
    _toastWidget(type, text, dismissible, onPressed),
    position: ToastPosition(align: Alignment.bottomCenter, offset: -100.0),
    duration: toastDuration(type),
    handleTouch: true,
    dismissOtherToast: true,
    animationBuilder: (context, child, controller, percent) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(controller),
      child: child, // child is the value returned by pageBuilder
    ),
  );
}

Material _toastWidget(
    ToastType type, String text, bool dismissible, VoidCallback onPressed) {
  final Material child = Material(
    type: MaterialType.transparency,
    child: Container(
      margin: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 60,
      ),
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: RoundedRectangleClipper(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Color(0x99151023),
            child: Row(
              children: <Widget>[
                toastIcon(type),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                dismissible
                    ? InkWell(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onTap: onPressed,
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return child;
}

Icon toastIcon(ToastType type) {
  switch (type) {
    case ToastType.Message:
      return Icon(
        Icons.chat_bubble_outline,
        color: Colors.white,
      );
    case ToastType.Alert:
      return Icon(
        Icons.error,
        color: Colors.redAccent,
      );
    case ToastType.Warning:
      return Icon(
        Icons.warning,
        color: Colors.orange[400],
      );
    case ToastType.Info:
      return Icon(
        Icons.info_outline,
        color: Colors.white,
      );
    default:
      throw NotFoundException("没有对应的Toast类型");
  }
}

Duration toastDuration(ToastType type) {
  switch (type) {
    case ToastType.Message:
      return Duration(
        seconds: 3,
      );
    case ToastType.Alert:
      return Duration(
        seconds: 5,
      );
    case ToastType.Warning:
      return Duration(
        seconds: 5,
      );
    case ToastType.Info:
      return Duration(
        seconds: 3,
      );
    default:
      throw NotFoundException("没有对应的Toast类型");
  }
}

class RoundedRectangleClipper extends CustomClipper<Path> {
  final double radius;

  RoundedRectangleClipper({this.radius});

  @override
  Path getClip(Size size) {
    final radius = this.radius ?? size.height / 2;
    final path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
    );
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

double calcTrueTextWidth(double textSize, String text) {
  // 测量实际长度
  var paragraph = ParagraphBuilder(ParagraphStyle(fontSize: textSize))
    ..addText(text);
  var p = paragraph.build()
    ..layout(ParagraphConstraints(width: double.infinity));
  return p.minIntrinsicWidth;
}

Size calcTrueTextSize(
  double textSize,
  String text,
  BoxConstraints constraint,
  int maxLines,
) {
  // 测量实际长度
  var paragraph = ParagraphBuilder(ParagraphStyle(fontSize: textSize))
    ..addText(text);
  var p = paragraph.build()
    ..layout(ParagraphConstraints(width: constraint.maxWidth));

  RenderParagraph renderParagraph = RenderParagraph(
    TextSpan(
      text: text,
      style: TextStyle(
        fontSize: textSize,
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: maxLines,
  );
  renderParagraph.layout(constraint);
  double height =
      renderParagraph.getMinIntrinsicHeight(textSize).ceilToDouble();
  renderParagraph.getMaxIntrinsicHeight(textSize).ceilToDouble();
  return Size(p.minIntrinsicWidth, height);
}

final intl.DateFormat dateFormat = intl.DateFormat("yyyy年MM月dd日 HH:mm:ss");

String formattedTime(String time) =>
    dateFormat.format(DateTime.tryParse(time)?.toLocal() ?? DateTime.now());
