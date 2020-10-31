import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

class AnimatedOnPressContainer extends StatefulWidget {
  final Function pressEvent;
  final Widget child;

  const AnimatedOnPressContainer(
      {@required this.pressEvent, @required this.child});
  @override
  _AnimatedOnPressContainerState createState() =>
      _AnimatedOnPressContainerState();
}

class _AnimatedOnPressContainerState extends State<AnimatedOnPressContainer>
    with AnimationMixin {
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
// Connect tween and controller and apply to animation variable
    final curveAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    );
    _scale = Tween<double>(begin: 1, end: 0.9).animate(curveAnimation);
  }

  void _onTapDown(TapDownDetails details) {
    controller.play(duration: Duration(milliseconds: 150));
  }

  void _onTapUp(TapUpDetails details) {
    if (controller.isAnimating) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.playReverse(duration: Duration(milliseconds: 100));
      });
    } else
      controller.playReverse(duration: Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.pressEvent,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        controller.playReverse(duration: Duration(milliseconds: 100));
      },
      child: Transform.scale(
        scale: _scale.value,
        child: widget.child,
      ),
    );
  }
}
