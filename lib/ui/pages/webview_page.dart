import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/database/collection_db_manager.dart';
import 'package:gankcamp_flutter/model/collection_info.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:webview_flutter/webview_flutter.dart';

enum PopupMenuOpTypeEnum {
  COPY_URL,
  DEF_BROWSER,
}

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  WebViewPage(this.title, this.url);

  @override
  State createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isHideLoading = false;
  CollectionInfo _collectionInfo;
  CollectionDBManager _collectionDBManager;

  @override
  void initState() {
    super.initState();
    _collectionDBManager = CollectionDBManager();
    _collectionDBManager
        .getCollectionByTitleAndUrl(widget.title, widget.url)
        .then((collection) {
      setState(() {
        _collectionInfo = collection;
      });
    });
  }

  void _onPopupMenuClick(PopupMenuOpTypeEnum opType) {
    switch (opType) {
      case PopupMenuOpTypeEnum.COPY_URL:
        Clipboard.setData(ClipboardData(text: widget.url));
        Fluttertoast.showToast(msg: '链接复制成功');
        break;
      case PopupMenuOpTypeEnum.DEF_BROWSER:
        UrlLauncher.launch(widget.url);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 14), maxLines: 2,),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
        actions: <Widget>[
          IconButton(
            icon: _collectionInfo != null
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            tooltip: _collectionInfo != null ? '取消收藏' : "收藏",
            onPressed: () async {
              if (_collectionInfo == null) {
                // 当前没有收藏，去收藏
                CollectionInfo saveCollectionInfo = await _collectionDBManager
                    .add(CollectionInfo(title: widget.title, url: widget.url));
                Fluttertoast.showToast(msg: '收藏成功');
                setState(() {
                  _collectionInfo = saveCollectionInfo;
                });
              } else {
                // 当前有收藏，去取消收藏
                await _collectionDBManager.remove(_collectionInfo.id);
                Fluttertoast.showToast(msg: '取消收藏成功');
                setState(() {
                  _collectionInfo = null;
                });
              }
            },
          ),
          PopupMenuButton<PopupMenuOpTypeEnum>(
            onSelected: _onPopupMenuClick,
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<PopupMenuOpTypeEnum>>[
                  PopupMenuItem<PopupMenuOpTypeEnum>(
                    value: PopupMenuOpTypeEnum.COPY_URL,
                    child: Text('复制URL'),
                  ),
                  PopupMenuItem<PopupMenuOpTypeEnum>(
                    value: PopupMenuOpTypeEnum.DEF_BROWSER,
                    child: Text('默认浏览器打开'),
                  ),
                ],
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
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
