//SimpleAnimationLibrary
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

//Helper Enum Class
enum SlideFrom { TOP, BOTTOM, LEFT, RIGHT }

Offset getOffset(MultiTweenValues<AniProps> animation, SlideFrom from) {
  switch (from) {
    case SlideFrom.TOP:
      return Offset(0, -animation.get(AniProps.translateX));
      break;
    case SlideFrom.BOTTOM:
      return Offset(0, animation.get(AniProps.translateX));
      break;
    case SlideFrom.LEFT:
      return Offset(-animation.get(AniProps.translateX), 0);
      break;
    case SlideFrom.RIGHT:
      return Offset(animation.get(AniProps.translateX), 0);
      break;
    default:
      return Offset(0, 0);
  }
}

//SimpleAnimationLibrary
enum AniProps { opacity, translateX, scale }

class Fade extends StatelessWidget {
  final double delay;
  final Widget child;
  final CustomAnimationControl control;

  final bool fade;
  final Curve curve;
  final Duration duration;

  Fade(
      {this.delay = 0,
      this.child,
      this.fade = true,
      this.control = CustomAnimationControl.PLAY,
      this.curve = Curves.ease,
      this.duration});

  @override
  Widget build(BuildContext context) {
    final newTween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0),
          duration ?? Duration(milliseconds: 500));

    return CustomAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (200 * delay).round()),
      control: control,
      duration: newTween.duration,
      tween: newTween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: fade ? animation.get(AniProps.opacity) : 1,
        child: child,
      ),
    );
  }
}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final CustomAnimationControl control;
  final SlideFrom from;
  final bool fade;
  final Curve curve;
  final Duration duration;

  FadeIn(
      {this.delay = 0,
      this.child,
      this.fade = true,
      this.control = CustomAnimationControl.PLAY,
      this.from = SlideFrom.RIGHT,
      this.curve = Curves.ease,
      this.duration});

  @override
  Widget build(BuildContext context) {
    final newTween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0),
          duration ?? Duration(milliseconds: 500))
      ..add(AniProps.translateX, Tween(begin: 60.0, end: 0.0),
          duration ?? Duration(milliseconds: 500), curve);

    return CustomAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (200 * delay).round()),
      control: control,
      duration: newTween.duration,
      tween: newTween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: fade ? animation.get(AniProps.opacity) : 1,
        child: Transform.translate(
          offset: getOffset(animation, from),
          child: child,
        ),
      ),
    );
  }
}

class ScaleFade extends StatelessWidget {
  final double delay;
  final Widget child;
  final CustomAnimationControl control;
  final double duration;
  final bool fade;
  final double scale;
  final Curve curve;
  ScaleFade({
    this.delay = 0,
    this.duration = 1,
    this.child,
    this.fade = true,
    this.scale = 0.7,
    this.control = CustomAnimationControl.PLAY,
    this.curve = Curves.easeIn,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(
        AniProps.opacity,
        fade ? Tween(begin: 0.0, end: 1.0) : Tween(begin: 1.0, end: 1.0),
        Duration(milliseconds: (150 * duration).round()),
      )
      ..add(AniProps.scale, Tween(begin: scale, end: 1.0),
          Duration(milliseconds: (150 * duration).round()), curve);

    return CustomAnimation<MultiTweenValues<AniProps>>(
        delay: Duration(milliseconds: (200 * delay).round()),
        control: control,
        duration: tween.duration,
        tween: tween,
        child: child,
        builder: (context, child, animation) => Opacity(
              opacity: animation.get(AniProps.opacity),
              child: Transform.scale(
                scale: animation.get(AniProps.scale),
                alignment: Alignment.center,
                child: child,
                //offset: Offset(animation["translateX"], 0), child: child),
              ),
            ));
  }
}
