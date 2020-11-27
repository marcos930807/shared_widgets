import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomModal extends StatelessWidget {
  final Widget child;
  final double heightFactor;
  const BottomModal({@required this.child, this.heightFactor = 0.2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * heightFactor,
              height: 3,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            SizedBox(height: 18),
            child
          ],
        ),
      ),
    );
  }
}
