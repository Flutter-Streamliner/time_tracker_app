import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final double height;
  final Color color;

  CustomRaisedButton({
    @required this.child, 
    this.onPressed, 
    this.color, 
    this.height : 50.0 ,
    this.borderRadius : 2.0
  }) : assert (borderRadius != null),
      assert (height != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
        child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))
        ),
      ),
    );
  }
}