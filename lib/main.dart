import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'pages/maintab/main_tab_gank.dart';
import 'pages/maintab/main_tab_rec.dart';
import 'pages/maintab/main_tab_girl.dart';
import 'pages/maintab/main_tab_me.dart';

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

class _RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>.value(true),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.black,
          fontSize: 17,
        ),
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
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
            backgroundColor: Color(0xFF00eeff),
          ),
          tabBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                  builder: (BuildContext context) => MainTabGank(),
                );
                break;
              case 1:
                return CupertinoTabView(
                  builder: (BuildContext context) => MainTabRec(),
                );
                break;
              case 2:
                return CupertinoTabView(
                  builder: (BuildContext context) => MainTabGirl(),
                );
                break;
              case 3:
                return CupertinoTabView(
                  builder: (BuildContext context) => MainTabMe(),
                );
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}
