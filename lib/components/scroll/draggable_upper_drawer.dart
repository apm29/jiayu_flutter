import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// author : apm29
/// date : 2020-01-21 13:42
/// description :
///
class DraggableUpperDrawerWidget extends StatefulWidget {
  @override
  _DraggableUpperDrawerWidgetState createState() =>
      _DraggableUpperDrawerWidgetState();
}

class _DraggableUpperDrawerWidgetState extends State<DraggableUpperDrawerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation<double> get anim => Tween(begin: 1.0, end: 0.0).animate(controller);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    print(_bottomHeight);
    controller?.dispose();
  }

  final GlobalKey _drawerBottomKey = GlobalKey();
  final GlobalKey _drawerTopKey = GlobalKey();
  final GlobalKey _drawerHandlerKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();

  double get _bottomHeight {
    final RenderBox box =
        _drawerBottomKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _topHeight {
    final RenderBox box =
        _drawerTopKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _dragHandlerHeight {
    final RenderBox box =
    _drawerHandlerKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _stackHeight {
    final RenderBox box =
    _stackKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  @override
  Widget build(BuildContext context) {
    Widget background = Container();
    Widget down =Container(
      color: Colors.indigo,
      constraints: BoxConstraints.expand(
        height: _stackHeight - _dragHandlerHeight,
      ),
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: false,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 60,
            refreshIndicatorExtent: 60,
          ),
          ...Iterable.generate(30, (index) => index)
              .map((c) => SliverToBoxAdapter(
              child: Text(
                c.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 40,
                ),
              )))
        ],
      ),
    );
    Widget upper = Image.asset('assets/images/jiayu_logo.png');
    Widget dragHandler = buildDragHandler();
    return Stack(
      key: _stackKey,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: background),
        Align(
          alignment: Alignment(0.0, -1.0),
          child: Container(
            child: upper,
            key: _drawerTopKey,
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: _topHeight * controller.value,
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails dragDetail) {
              var delta = dragDetail.primaryDelta / _topHeight;
              controller.value += delta;
            },
            onVerticalDragEnd: (DragEndDetails dragDetail) {
              if (controller.value < 0.5) {
                controller.reverse(from: controller.value);
              } else {
                controller.forward(from: controller.value);
              }
            },
            child: Column(
              key: _drawerBottomKey,
              children: <Widget>[
                dragHandler,
                AbsorbPointer(
                  absorbing: controller.value == 1.0,
                  child: down,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container buildDragHandler() {
    return Container(
      key: _drawerHandlerKey,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Expanded(child: Text("Draggable")),
          InkWell(
            onTap: _closeOrOpen,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: anim,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _closeOrOpen() {
    if (controller.value > 0.5) {
      controller.reverse(from: controller.value);
    } else {
      controller.forward(from: controller.value);
    }
  }
}

typedef AnimatedWidgetBuilder = Widget Function(
    BuildContext, Animation, Widget);
typedef PositionedAnimatedWidgetBuilder = Widget Function(
    BuildContext, Animation, Widget,
    {double top, double dragHandlerHeight, double minUpperExtend});

class UpDraggableDrawerWidget extends StatefulWidget {
  final Widget background;
  final AnimatedWidgetBuilder backgroundBuilder;
  final Widget upper;
  final AnimatedWidgetBuilder upperBuilder;
  final Widget bottom;
  final PositionedAnimatedWidgetBuilder bottomBuilder;
  final Widget dragHandler;
  final AnimatedWidgetBuilder dragHandlerBuilder;

  final double minUpperExtend;
  final bool draggableAtBottom;

  const UpDraggableDrawerWidget({
    Key key,
    this.background,
    this.upper,
    this.bottom,
    this.backgroundBuilder,
    this.upperBuilder,
    this.bottomBuilder,
    this.dragHandler,
    this.dragHandlerBuilder,
    this.minUpperExtend,
    this.draggableAtBottom = false,
  })  : assert(background != null || backgroundBuilder != null),
        assert(bottom != null || bottomBuilder != null),
        assert(upper != null || upperBuilder != null),
        assert(dragHandler != null || dragHandlerBuilder != null),
        super(key: key);

  @override
  UpDraggableDrawerWidgetState createState() => UpDraggableDrawerWidgetState();

  static UpDraggableDrawerWidgetState of(BuildContext context) =>
      context.findAncestorStateOfType<UpDraggableDrawerWidgetState>();
}

class UpDraggableDrawerWidgetState extends State<UpDraggableDrawerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation<double> get anim => Tween(begin: 1.0, end: 0.0).animate(controller);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    print(_bottomHeight);
    controller?.dispose();
  }

  final GlobalKey _drawerBottomKey = GlobalKey();
  final GlobalKey _drawerTopKey = GlobalKey();
  final GlobalKey _drawerCenterKey = GlobalKey();

  double get _bottomHeight {
    final RenderBox box =
        _drawerBottomKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _topHeight {
    final RenderBox box =
        _drawerTopKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _dragHandlerHeight {
    final RenderBox box =
        _drawerCenterKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 100; // drawer not being shown currently
  }

  double get _topMinHeight => widget.minUpperExtend ?? 48;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Widget background =
            widget.backgroundBuilder?.call(context, anim, widget.bottom) ??
                widget.background;

        Widget upper = widget.upperBuilder?.call(context, anim, widget.upper) ??
            widget.upper;
        Widget dragHandler = widget.dragHandlerBuilder
                ?.call(context, anim, widget.dragHandler) ??
            widget.dragHandler;
        var bottomTop =
            (_topHeight - _topMinHeight) * controller.value + _topMinHeight;

        Widget bottom = widget.bottomBuilder?.call(
              context,
              anim,
              widget.bottom,
              top: bottomTop,
              dragHandlerHeight: _dragHandlerHeight,
              minUpperExtend: _topMinHeight,
            ) ??
            widget.bottom;
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(child: background),
            Align(
              alignment: Alignment(0.0, -1.0),
              child: Container(
                child: upper,
                key: _drawerTopKey,
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: bottomTop,
              child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails dragDetail) {
                  var delta =
                      dragDetail.primaryDelta / (_topHeight - _topMinHeight);
                  controller.value += delta;
                },
                onVerticalDragEnd: (DragEndDetails dragDetail) {
                  if (controller.value < 0.5) {
                    controller.reverse(from: controller.value);
                  } else {
                    controller.forward(from: controller.value);
                  }
                },
                child: Column(
                  key: _drawerBottomKey,
                  children: <Widget>[
                    Container(
                      child: dragHandler,
                      key: _drawerCenterKey,
                    ),
                    AbsorbPointer(
                      absorbing:
                          !widget.draggableAtBottom && controller.value == 1.0,
                      child: Container(
                        color: Theme.of(context).backgroundColor,
                        child: bottom,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void closeOrOpen() {
    if (controller.value > 0.5) {
      controller.reverse(from: controller.value);
    } else {
      controller.forward(from: controller.value);
    }
  }
}
