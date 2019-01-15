import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/pages/widget/gank_list_widget.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';

const _allTabs = <String>['全部', 'Android', 'iOS', '前端', '瞎推荐', '休息视频', '拓展资源'];

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
            backgroundColor: AppColors.MAIN_COLOR,
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
            children: _allTabs
                .map<Widget>((tab) => GankListWidget(tab == '全部' ? 'all' : tab))
                .toList(),
          ),
        ));
  }
}
