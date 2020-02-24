import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_app/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_app/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TabItem _currentTab = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs : (_) => JobPage(),
      TabItem.entries : (_) => Container(),
      TabItem.account: (_) => Container(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }

  void _select(TabItem item) {
    setState(() => _currentTab = item);
  }
}