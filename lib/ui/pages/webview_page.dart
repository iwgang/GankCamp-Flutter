import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final GankInfo gankInfo;

  WebViewPage(this.gankInfo);

  @override
  State createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gankInfo.desc),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (_) {
          print('加载完成');
        },
        initialUrl: widget.gankInfo.url,
      ),
    );
  }
}
