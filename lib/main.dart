import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'ui/pages/maintab/main_tab_gank.dart';
import 'ui/pages/maintab/main_tab_rec.dart';
import 'ui/pages/maintab/main_tab_girl.dart';
import 'ui/pages/maintab/main_tab_me.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '干货集中营',
      home: _RootWidget(),
    );
  }
}

class _RootWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootState();
}

class _RootState extends State<_RootWidget>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  var _tabPageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _tabPageController.dispose();
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          title: Text('干货'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.conversation_bubble),
          title: Text('推荐'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.shuffle_thick),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _tabPageController,
        children: <Widget>[
          MainTabGankWidget(),
          MainTabRecWidget(),
          MainTabGirl(),
          MainTabMe(),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
