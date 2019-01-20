import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Text(
              '    这是一款用 Flutter 实现的 Gank.io(干货集中营) 客户端，支持 Android、iOS及其它支持 Flutter 的设备.\n    这里每日分享妹子图和技术干货，还有供大家休息放松时看的视频，让你休闲技术两不误.',
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: InkWell(
              child: Text(
                '本项目已在 Github 上开源，点击直达',
                style: TextStyle(
                  color: Color(0xff999999),
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              onTap: () => UrlLauncher.launch(
                  'https://github.com/iwgang/GankCampFlutter'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 15),
            child: Row(
              children: <Widget>[
                Text('感谢'),
                InkWell(
                  child: Text(
                    ' Gank.io ',
                    style: TextStyle(
                      color: Color(0xff999999),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  onTap: () => UrlLauncher.launch('https://gank.io'),
                ),
                Text('提供数据api'),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 30,
              left: 10,
            ),
            child: Text(
              '关于作者',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 5,
              left: 20,
            ),
            child: Text(
              'Email：iwgang@163.com',
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 5,
              left: 20,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Github：',
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
                InkWell(
                  child: Text(
                    'github.com/iwgang',
                    style: TextStyle(
                      color: Color(0xff999999),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  onTap: () => UrlLauncher.launch('https://github.com/iwgang'),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 5,
              left: 20,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'WeiBo：',
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
                InkWell(
                  child: Text(
                    'weibo.com/iwgang',
                    style: TextStyle(
                      color: Color(0xff999999),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  onTap: () => UrlLauncher.launch('https://weibo.com/iwgang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
