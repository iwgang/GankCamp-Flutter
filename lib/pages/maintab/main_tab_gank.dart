import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/pages/widget/gank_list_widget.dart';

const _allTabs = <String>[
  'Android',
  'iOS',
  '前端',
  '拓展资源',
  '休息视频',
  '休息视频3',
  '休息视频5',
];

class MainTabGank extends StatefulWidget {
  @override
  State createState() => _MainTabGankState();
}

class _MainTabGankState extends State<MainTabGank> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _allTabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text('干货'),
            elevation: 0,
            bottom: TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 3)),
              tabs: _allTabs.map<Tab>((tab) => Tab(text: tab)).toList(),
            ),
          ),
          body: TabBarView(
            children:
                _allTabs.map<Widget>((tab) => GankListWidget(tab)).toList(),
          ),
        ));
  }
}
