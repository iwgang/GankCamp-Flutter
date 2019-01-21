import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/constant/common_utils.dart';
import 'package:gankcamp_flutter/database/collection_db_manager.dart';
import 'package:gankcamp_flutter/model/collection_info.dart';
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';

class CollectionPage extends StatefulWidget {
  @override
  State createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<CollectionInfo> _collectionInfo;
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
        _collectionInfo = res;
      });
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
              itemCount: _collectionInfo?.length ?? 0,
              itemBuilder: (context, index) => InkWell(
                    child: _ItemView(_collectionInfo[index]),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final curInfo = _collectionInfo[index];
                          return WebViewPage(curInfo.title, curInfo.url);
                        }),
                      );
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
