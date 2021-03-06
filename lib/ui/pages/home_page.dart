import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gankcamp_flutter/ui/pages/maintab/main_tab_gank.dart';
import 'package:gankcamp_flutter/ui/pages/maintab/main_tab_girl.dart';
import 'package:gankcamp_flutter/ui/pages/maintab/main_tab_me.dart';
import 'package:gankcamp_flutter/ui/pages/maintab/main_tab_rec.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  int _lastBackMillisecond = 0;
  var _tabPageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _tabPageController.dispose();
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      fixedColor: Colors.green,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          title: Text('干货'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.share),
          title: Text('推荐'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          title: Text('妹纸'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: Text('我的'),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _tabIndex,
      onTap: (index) {
        _tabPageController.jumpToPage(index);
        setState(() {
          _tabIndex = index;
        });
      },
    );
  }

  Future<bool> _onBack() {
    final curBackMillisecond = DateTime.now().millisecondsSinceEpoch;
    if (curBackMillisecond - _lastBackMillisecond > 2000) {
      _lastBackMillisecond = curBackMillisecond;
      Fluttertoast.showToast(msg: '再按一次退出APP');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabPageController,
          children: <Widget>[
            MainTabGankWidget(),
            MainTabRecWidget(),
            MainTabGirlWidget(),
            MainTabMe(),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }
}
