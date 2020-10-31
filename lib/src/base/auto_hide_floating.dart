import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_animations/simple_animations.dart';

import 'anims.dart';

class AutoHideFloating extends StatefulWidget {
  AutoHideFloating(
      {Key key, @required this.scrollController, @required this.floating})
      : super(key: key);
  final ScrollController scrollController;
  final Widget floating;
  @override
  _AutoHideFloatingState createState() => _AutoHideFloatingState();
}

class _AutoHideFloatingState extends State<AutoHideFloating> {
  bool isVisible = true;
  void setVisible(bool value) {
    if (value != isVisible)
      setState(() {
        isVisible = value;
      });
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      //ParentScroolListener for showing and hiding
      //Show if User scroll up or List is in the begining. otherwise Hide
      setVisible(widget.scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          widget.scrollController.position.extentBefore == 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      control: isVisible
          ? CustomAnimationControl.PLAY
          : CustomAnimationControl.PLAY_REVERSE,
      child: widget.floating,
    );
  }
}
