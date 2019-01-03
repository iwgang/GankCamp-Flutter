import 'package:flutter/material.dart';

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

class _MainTabGankState extends State<MainTabGank>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allTabs.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('干货'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.green,
            child: tabBarWidget(),
          ),
          Expanded(
            child: bodyWidget(),
          )
        ],
      ),
    );
  }

  Widget tabBarWidget() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.black, width: 3)),
      tabs: _allTabs.map<Tab>((tab) => Tab(text: tab)).toList(),
    );
  }

  Widget bodyWidget() {
    return TabBarView(
      controller: _controller,
      children: _allTabs
          .map<Widget>((tab) => Container(
                child: Center(
                  child: Text(tab),
                ),
              ))
          .toList(),
    );
  }
}
