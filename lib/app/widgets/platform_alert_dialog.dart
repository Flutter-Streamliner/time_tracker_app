import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/app/widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
   
  final String title;
  final String content;
  final String defaultActionText;

  PlatformAlertDialog({
    @required this.title, 
    @required this.content, 
    @required this.defaultActionText
  }) : assert (title != null), assert(content != null), assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    throw CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    throw AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }

}

class PlatformAlertDialogAction extends PlatformWidget {

  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    throw CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    throw FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }

}