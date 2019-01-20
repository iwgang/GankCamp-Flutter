import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'dart:async';

class WebViewPage extends StatefulWidget {
  final GankInfo gankInfo;

  WebViewPage(this.gankInfo);

  @override
  State createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isHideLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gankInfo.desc),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.gankInfo.url,
            onWebViewCreated: (_) {
              // 由于没找到获取页面加载完成的回调，只能给个固定加载时间
              Timer(Duration(seconds: 2), () {
                setState(() {
                  _isHideLoading = true;
                });
              });
            },
          ),
          Offstage(
            offstage: _isHideLoading,
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
