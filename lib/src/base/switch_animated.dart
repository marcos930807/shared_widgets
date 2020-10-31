import 'dart:math';

import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

typedef AsyncVerification = Future<bool> Function();

class SwitchTile extends StatefulWidget {
  @override
  _SwitchTileState createState() => _SwitchTileState();
  final AsyncVerification asyncVerificationBeforeOn;
  final AsyncVerification asyncVerificationBeforeOff;
  final bool initialStaus;
  final String activeStr;
  final String desactiveStr;

  /// called whenever the value of the Swicth changed
  final ValueChanged<bool> onChanged;
  const SwitchTile(
      {Key key,
      this.initialStaus,
      this.onChanged,
      this.activeStr = 'Activado',
      this.desactiveStr = 'Desactivado',
      this.asyncVerificationBeforeOn,
      this.asyncVerificationBeforeOff})
      : super(key: key);
}

class _SwitchTileState extends State<SwitchTile> {
  bool innerStatus;
  @override
  void initState() {
    super.initState();
    innerStatus = widget.initialStaus;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!innerStatus) {
          if (widget.asyncVerificationBeforeOn == null) {
            _toggle();
          } else {
            if (await widget.asyncVerificationBeforeOn()) {
              _toggle();
            }
          }
        } else {
          if (widget.asyncVerificationBeforeOff == null) {
            _toggle();
          } else {
            if (await widget.asyncVerificationBeforeOff()) {
              _toggle();
            }
          }
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: <Widget>[
          SwitchlikeCheckbox(checked: innerStatus),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              innerStatus ? widget.activeStr : widget.desactiveStr,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          )
        ],
      ),
    );
  }

  void _toggle() async {
    setState(() {
      innerStatus = !innerStatus;
      if (widget.onChanged != null) {
        widget.onChanged(innerStatus);
      }
    });
  }
}

enum SwitchProps { paddingLeft, color, text, rotation }

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;

  SwitchlikeCheckbox({this.checked});

  @override
  Widget build(BuildContext context) {
    var newTween = MultiTween<SwitchProps>()
      ..add(SwitchProps.paddingLeft, Tween(begin: 0.0, end: 20.0),
          Duration(milliseconds: 1000))
      ..add(
          SwitchProps.color,
          ColorTween(begin: Colors.grey, end: Colors.green),
          Duration(milliseconds: 1000))
      ..add(SwitchProps.text, ConstantTween("OFF"), Duration(milliseconds: 500))
      ..add(SwitchProps.text, ConstantTween("ON"), Duration(milliseconds: 500))
      ..add(SwitchProps.rotation, Tween(begin: -2 * pi, end: 0.0),
          Duration(milliseconds: 1000));

    return CustomAnimation<MultiTweenValues<SwitchProps>>(
      control: checked
          ? CustomAnimationControl.PLAY
          : CustomAnimationControl.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: newTween.duration * 1.2,
      tween: newTween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(
      context, child, MultiTweenValues<SwitchProps> animation) {
    return Container(
      decoration: _outerBoxDecoration(animation.get(SwitchProps.color)),
      width: 50,
      height: 30,
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
            padding:
                EdgeInsets.only(left: animation.get(SwitchProps.paddingLeft)),
            child: Transform.rotate(
              angle: animation.get(SwitchProps.rotation),
              child: Container(
                decoration:
                    _innerBoxDecoration(animation.get(SwitchProps.color)),
                width: 20,
                child: Center(
                    child: Text(animation.get(SwitchProps.text),
                        style: labelStyle)),
              ),
            ),
          ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)), color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          width: 2,
          color: color,
        ),
      );

  static final labelStyle = TextStyle(
      height: 1.2,
      fontWeight: FontWeight.bold,
      fontSize: 9,
      color: Colors.white);
}
