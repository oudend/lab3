import 'package:flutter/material.dart';

class AnimatedSideBarView extends StatefulWidget {
  const AnimatedSideBarView({
    super.key,
    required this.sideBar,
    required this.child,
    required this.onCollapse,
    this.collapsed = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.barRatio = 0,
    this.minBarWidth = 0,
    this.maxBarWidth = 200,
    this.handleWidth = 6,
  });

  final double minBarWidth;
  final double maxBarWidth;
  final double barRatio;

  final Function(bool) onCollapse;

  final double handleWidth;

  final bool collapsed;
  final Widget sideBar;

  final Duration duration;
  final Curve curve;

  final Widget child;

  @override
  State<AnimatedSideBarView> createState() => _AnimatedSideBarViewState();
}

class _AnimatedSideBarViewState extends State<AnimatedSideBarView> {
  late bool _collapsed;

  bool dragged = false;

  late double _barWidth;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.collapsed;

    _barWidth = _defaultBarWidth();
  }

  @override
  void didUpdateWidget(covariant AnimatedSideBarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.collapsed != widget.collapsed) {
      setState(() {
        _collapsed = widget.collapsed;
        if (!_collapsed) {
          _barWidth = _defaultBarWidth();
        }
      });
    }
  }

  double _defaultBarWidth() {
    final width =
        widget.minBarWidth +
        (widget.maxBarWidth - widget.minBarWidth) * widget.barRatio;
    return width.clamp(widget.minBarWidth, widget.maxBarWidth);
  }

  void toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: dragged ? Duration.zero : widget.duration,
          curve: widget.curve,
          width: _collapsed ? 0 : _barWidth,
          child: _collapsed ? null : widget.sideBar,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              setState(() {
                dragged = true;
                _collapsed = false;
                _barWidth += details.delta.dx;
                _barWidth = _barWidth.clamp(
                  widget.minBarWidth,
                  widget.maxBarWidth,
                ); // min/max

                widget.onCollapse(_collapsed);
              });
            },
            onHorizontalDragEnd: (details) => dragged = false,
            onHorizontalDragCancel: () => dragged = false,
            child: SizedBox(
              width: widget.handleWidth,
              height: double.infinity,
              child: ColoredBox(color: Colors.black45),
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
