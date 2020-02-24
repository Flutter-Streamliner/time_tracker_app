import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  CupertinoHomeScaffold({Key key, @required this.currentTab, @required this.onSelectTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem item) {
    final itemData = TabItemData.allTabs[item];
    final color = currentTab == item ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon, color: color,),
      title: Text(itemData.title, style: TextStyle(color: color),),
    );
  }

}