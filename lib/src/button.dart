import 'dart:math' show pow;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Button extends StatefulWidget {
  const Button({
    Key? key,
    this.icon,
    this.iconSize,
    this.leading,
    this.iconActiveColor,
    this.iconColor,
    this.text,
    this.textStyle,
    this.gap,
    this.color,
    this.rippleColor,
    this.hoverColor,
    required this.onPressed,
    this.duration,
    this.curve,
    this.padding,
    this.margin,
    required this.active,
    this.debug,
    this.gradient,
    this.borderRadius,
    this.border,
    this.activeBorder,
    this.shadow,
    this.alwaysShowText = false,
  }) : super(key: key);

  final IconData? icon;
  final double? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final Widget? leading;
  final Color? iconActiveColor;
  final Color? iconColor;
  final Color? color;
  final Color? rippleColor;
  final Color? hoverColor;
  final double? gap;
  final bool? active;
  final bool? debug;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration? duration;
  final Curve? curve;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Border? border;
  final Border? activeBorder;
  final List<BoxShadow>? shadow;
  final bool alwaysShowText;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController expandController;

  @override
  void initState() {
    super.initState();
    _expanded = widget.active!;

    expandController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var curveValue = expandController
        .drive(CurveTween(
            curve: _expanded ? widget.curve! : widget.curve!.flipped))
        .value;
    var _colorTween =
        ColorTween(begin: widget.iconColor, end: widget.iconActiveColor);
    var _colorTweenAnimation = _colorTween.animate(CurvedAnimation(
        parent: expandController,
        curve: _expanded ? Curves.easeInExpo : Curves.easeOutCirc));

    _expanded = !widget.active!;
    if (_expanded)
      expandController.reverse();
    else
      expandController.forward();

    Widget icon = widget.leading ??
        FaIcon(widget.icon,
            color: _colorTweenAnimation.value, size: widget.iconSize);

    Text text = Text(
      widget.text ?? '',
      style: widget.textStyle != null
          ? widget.textStyle!.copyWith(
              color: _expanded ? widget.iconColor : widget.textStyle!.color,
            )
          : TextStyle(
              color: _expanded
                  ? widget.iconColor ?? Colors.black87
                  : widget.textStyle?.color ?? Colors.white,
            ),
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: widget.margin,
        child: InkWell(
          highlightColor: widget.hoverColor,
          splashColor: widget.rippleColor,
          borderRadius: widget.borderRadius,
          onTap: widget.onPressed,
          child: AnimatedContainer(
            curve: Curves.easeOut,
            padding: widget.padding,
            duration: widget.duration!,
            decoration: BoxDecoration(
              boxShadow: widget.shadow,
              border: widget.active!
                  ? (widget.activeBorder ?? widget.border)
                  : widget.border,
              gradient: widget.gradient,
              color: _expanded
                  ? widget.color!.withOpacity(0)
                  : widget.debug!
                      ? Colors.red
                      : widget.gradient != null
                          ? Colors.white
                          : widget.color,
              borderRadius: widget.borderRadius,
            ),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Stack(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Opacity(
                      opacity: 0,
                      child: icon,
                    ),
                    !widget.alwaysShowText
                        ? Container(
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerRight,
                                widthFactor: curveValue,
                                child: Container(
                                  child: Opacity(
                                    opacity: _expanded
                                        ? pow(expandController.value, 13)
                                            as double
                                        : expandController
                                            .drive(CurveTween(
                                                curve: Curves.easeIn))
                                            .value,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: widget.gap! +
                                              8 -
                                              (8 *
                                                  expandController
                                                      .drive(CurveTween(
                                                          curve: Curves
                                                              .easeOutSine))
                                                      .value),
                                          right: 8 *
                                              expandController
                                                  .drive(CurveTween(
                                                      curve:
                                                          Curves.easeOutSine))
                                                  .value),
                                      child: text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              left: widget.gap!,
                              right: 8,
                            ),
                            child: text,
                          )
                  ],
                ),
                SizedBox(
                  height: 26,
                  child: Center(
                    child: icon,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
