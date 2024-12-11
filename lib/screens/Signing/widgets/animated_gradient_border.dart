import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    this.radius = 20,
    this.blurRadius = 15,
    this.spreadRadius = 2,
    this.topColor = Colors.purple,
    this.bottomColor = Colors.blue,
    this.glowOpacity = 0.3,
    this.duration = const Duration(milliseconds: 500),
    this.thickness = 7,
    this.child,
  });
// the radius of the border
  final double radius;

  //blur radius of the glow effect
  final double blurRadius;

  //spread radius of the glow effect
  final double spreadRadius;

  //the color of the top of the gradient
  final Color topColor;

  //the color of the bottom of the gradient
  final Color bottomColor;

  //the opacity of the glow effect
  final double glowOpacity;

  //the duration of the animation, the default is 500 milliseconds
  final Duration duration;

  //the thickness of the border
  final double thickness;

  final Widget? child;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignAnim;
  late Animation<Alignment> _bottomAlignAnim;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: widget.duration);
    _topAlignAnim = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.topLeft, end: Alignment.topRight),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.topRight, end: Alignment.bottomRight),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.bottomLeft, end: Alignment.topLeft),
            weight: 1),
      ],
    ).animate(_controller);

    _bottomAlignAnim = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.bottomLeft, end: Alignment.topLeft),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.topLeft, end: Alignment.topRight),
            weight: 1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(
                begin: Alignment.topRight, end: Alignment.bottomRight),
            weight: 1),
      ],
    ).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            widget.child == null
                ? const SizedBox.shrink()
                : ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                    child: widget.child,
                  ),
            ClipPath(
              clipper: _CenterCutPath(
                  radius: widget.radius, thickness: widget.thickness),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(widget.radius)),
                            boxShadow: [
                              BoxShadow(
                                  color: widget.topColor,
                                  offset: const Offset(0, 0),
                                  blurRadius: widget.blurRadius,
                                  spreadRadius: widget.spreadRadius)
                            ]),
                      ),
                      Align(
                        alignment: _bottomAlignAnim.value,
                        child: Container(
                          width: constraints.maxWidth * 0.95,
                          height: constraints.maxHeight * 0.95,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(widget.radius)),
                              boxShadow: [
                                BoxShadow(
                                    color: widget.bottomColor,
                                    offset: const Offset(0, 0),
                                    blurRadius: widget.blurRadius,
                                    spreadRadius: widget.spreadRadius)
                              ]),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(widget.radius)),
                            gradient: LinearGradient(
                                begin: _topAlignAnim.value,
                                end: _bottomAlignAnim.value,
                                colors: [widget.topColor, widget.bottomColor])),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    _controller.dispose(); // Properly dispose of the AnimationController
    super.dispose();
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;
  _CenterCutPath({this.radius = 0, this.thickness = 1});

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(
        -size.width, -size.width, size.width * 2, size.height * 2);
    final double width = size.width - thickness * 2;
    final double height = size.height - thickness * 2;

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(thickness, thickness, width, height),
            Radius.circular(radius - thickness)),
      )
      ..addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}
