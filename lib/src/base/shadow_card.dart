import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  const ShadowCard({
    Key key,
    this.child,
    this.backGroundColor,
    this.gradient,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.margin,
  }) : super(key: key);
  final Widget child;
  final Color backGroundColor;
  final LinearGradient gradient;
  final Border border;
  final BorderRadius borderRadius;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.all(0),
      decoration: BoxDecoration(
          gradient: gradient,
          color: backGroundColor ?? Theme.of(context).cardColor,
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10)),
          border: border,
          boxShadow: <BoxShadow>[
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 8,
                color: Theme.of(context).primaryColor.withAlpha(20),
              )
          ]),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10)),
        child: Material(elevation: 0, color: Colors.transparent, child: child),
      ),
    );
  }

  factory ShadowCard.bordered({
    @required final BuildContext context,
    @required final Widget child,
    final EdgeInsetsGeometry margin,
    final double height,
    final double width,
    final BorderRadius borderRadius,
  }) {
    return ShadowCard(
      margin: margin,
      height: height,
      width: width,
      borderRadius: borderRadius,
      backGroundColor: Theme.of(context).accentColor,
      border: Theme.of(context).brightness == Brightness.light
          ? Border.all(
              width: 1, color: Theme.of(context).primaryColor.withAlpha(20))
          : null,
      child: child,
    );
  }
}
