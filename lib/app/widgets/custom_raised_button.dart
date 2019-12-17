import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final Color color;

  CustomRaisedButton({@required this.child, @required this.onPressed, this.color, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))
      ),
    );
  }
}