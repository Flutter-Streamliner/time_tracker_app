import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  CupertinoHomeScaffold({Key key, @required this.currentTab, @required this.onSelectTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}