import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/constant/common_utils.dart';
import 'package:gankcamp_flutter/database/collection_db_manager.dart';
import 'package:gankcamp_flutter/model/collection_info.dart';
import 'package:gankcamp_flutter/model/collection_state_change.dart';
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';

class CollectionPage extends StatefulWidget {
  @override
  State createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<CollectionInfo> _collectionInfoList;
  CollectionDBManager _collectionDBManager;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _collectionDBManager = CollectionDBManager();
    _collectionList(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _collectionList([VoidCallback loadEndCallback]) async {
    List<CollectionInfo> res = await _collectionDBManager.list();
    if (null != loadEndCallback) loadEndCallback();
    if (null != res && res.isNotEmpty) {
      setState(() {
        _collectionInfoList = res;
      });
    }
  }

  void _itemLongClick(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('确定删除该条收藏吗？'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  '取消',
                  style: TextStyle(color: Color(0xff999999)),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await _collectionDBManager
                      .remove(_collectionInfoList[index].id);
                  setState(() {
                    _collectionInfoList.removeAt(index);
                  });
                },
                child: Text(
                  '确定',
                  style: TextStyle(color: AppColors.MAIN_COLOR),
                ),
              ),
            ],
          ),
    );
  }

  void _onWebViewPageResult(dynamic result) async {
    if (null != result &&
        result is CollectionStateChange &&
        result.id > 0 &&
        !result.isCollection) {
      int curIndex = -1;
      for (int i = 0; i < _collectionInfoList.length; i++) {
        if (_collectionInfoList[i].id == result.id) {
          curIndex = i;
          break;
        }
      }

      if (curIndex != -1) {
        await _collectionDBManager.remove(_collectionInfoList[curIndex].id);
        setState(() {
          _collectionInfoList.removeAt(curIndex);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading,
            child: ListView.builder(
              itemCount: _collectionInfoList?.length ?? 0,
              itemBuilder: (context, index) => InkWell(
                    child: _ItemView(_collectionInfoList[index]),
                    onLongPress: () => _itemLongClick(index),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final curInfo = _collectionInfoList[index];
                          return WebViewPage(
                            curInfo.title,
                            curInfo.url,
                            collectionId: curInfo.id,
                          );
                        }),
                      ).then(_onWebViewPageResult);
                    },
                  ),
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: SpinKitThreeBounce(
                color: AppColors.MAIN_COLOR,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final CollectionInfo collectionInfo;

  _ItemView(this.collectionInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.0,
            color: Color(0xffe5e5e5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            collectionInfo.title,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 8),
            child: Text(
              CommonUtils.formatTime(collectionInfo.time),
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
