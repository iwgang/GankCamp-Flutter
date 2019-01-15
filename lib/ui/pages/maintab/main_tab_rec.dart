import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';

class MainTabRecWidget extends StatefulWidget {
  @override
  State createState() => _MainTabState();
}

class _MainTabState extends State<MainTabRecWidget>
    with AutomaticKeepAliveClientMixin {
  final double _appBarHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.MAIN_COLOR,
            expandedHeight: _appBarHeight,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.date_range),
                tooltip: '切换日期',
                onPressed: () => print('edit...'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                '推荐：2019-01-04',
                style: TextStyle(fontSize: 17),
              ),
              background: Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546509702760&di=e77e8c31e2241c14894278d53df7230a&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a52958009e2ea84a0e282bd0d86c.jpg%402o.jpg",
                fit: BoxFit.cover,
                height: _appBarHeight,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(genList()),
          ),
        ],
      ),
    );
  }

  List<Widget> genList() {
    var retList = <Widget>[];
    for (var i = 0; i < 30; i++) {
      retList.add(Text(
        'i = $i',
        style: TextStyle(fontSize: 33),
      ));
    }
    return retList;
  }

  @override
  bool get wantKeepAlive => true;
}
