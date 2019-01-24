import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/database/collection_db_manager.dart';
import 'package:gankcamp_flutter/model/collection_info.dart';
import 'package:gankcamp_flutter/model/collection_state_change.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

enum PopupMenuOpTypeEnum {
  COPY_URL,
  DEF_BROWSER,
}

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final int collectionId;

  WebViewPage(this.title, this.url, {this.collectionId});

  @override
  State createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  CollectionInfo _collectionInfo;
  CollectionDBManager _collectionDBManager;
  CollectionStateChange _collectionStateChange;

  @override
  void initState() {
    super.initState();
    _collectionStateChange = CollectionStateChange();
    _collectionDBManager = CollectionDBManager();
    final collectionId = widget.collectionId;
    if (null != collectionId) {
      _collectionStateChange.id = collectionId;
      _collectionStateChange.isCollection = true;
      _collectionDBManager
          .getCollectionByID(collectionId)
          .then(_queryCollectionCallback);
    } else {
      _collectionDBManager
          .getCollectionByTitleAndUrl(widget.title, widget.url)
          .then(_queryCollectionCallback);
    }
  }

  void _queryCollectionCallback(CollectionInfo collection) {
    setState(() {
      _collectionInfo = collection;
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

  Future<bool> _onBack() {
    Navigator.of(context).pop(_collectionStateChange);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: WebviewScaffold(
        url: widget.url,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
          ),
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
                  CollectionInfo saveCollectionInfo =
                      await _collectionDBManager.add(
                          CollectionInfo(title: widget.title, url: widget.url));
                  Fluttertoast.showToast(msg: '收藏成功');
                  _collectionStateChange.isCollection = true;
                  setState(() {
                    _collectionInfo = saveCollectionInfo;
                  });
                } else {
                  // 当前有收藏，去取消收藏
                  await _collectionDBManager.remove(_collectionInfo.id);
                  Fluttertoast.showToast(msg: '取消收藏成功');
                  _collectionStateChange.isCollection = false;
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
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.MAIN_COLOR),
            ),
          ),
        ),
      ),
    );
  }
}
