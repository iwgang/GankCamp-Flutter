import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/constant/common_utils.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';
import 'package:gankcamp_flutter/ui/widget/refresh_common_widget.dart';

class GankListWidget extends StatefulWidget {
  final String type;

  GankListWidget(this.type);

  @override
  State createState() => _GankListWidgetState();
}

class _GankListWidgetState extends State<GankListWidget>
    with AutomaticKeepAliveClientMixin {
  List<GankInfo> _gankInfoList;
  int _pageNo = 1;
  bool _isLoading = true;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _onLoadMore();
        }
      });
    _gankList(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _gankList([VoidCallback loadEndCallback]) async {
    List<GankInfo> res =
        await GankApiManager.gankList(widget.type, _pageNo, 10);
    if (null != loadEndCallback) loadEndCallback();
    if (null != res && res.isNotEmpty) {
      if (_pageNo == 1) {
        setState(() {
          _gankInfoList = res;
        });
      } else {
        setState(() {
          _gankInfoList.addAll(res);
        });
      }
    }
  }

  Future<Null> _onRefresh() async {
    _pageNo = 1;
    await _gankList();
  }

  Future _onLoadMore() async {
    _pageNo++;
    await _gankList();
  }

  int _itemCount() => _gankInfoList != null && _gankInfoList.isNotEmpty
      ? _gankInfoList.length + 1
      : 0;

  Widget _itemView(context, index) {
    if (_gankInfoList.length > 0 && index == _gankInfoList.length) {
      return RefreshCommonWidget.commonLoadMoreWidget();
    } else {
      return InkWell(
        child: _ItemView(_gankInfoList[index]),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              final curInfo = _gankInfoList[index];
              return WebViewPage(curInfo.desc, curInfo.url);
            }),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isLoading,
          child: RefreshIndicator(
            color: AppColors.MAIN_COLOR,
            onRefresh: _onRefresh,
            child: Scrollbar(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _itemCount(),
                itemBuilder: _itemView,
              ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemView extends StatelessWidget {
  final GankInfo gankInfo;

  _ItemView(this.gankInfo);

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
            gankInfo.desc,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'via：${gankInfo.who}',
                    style: TextStyle(
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                Text(
                  CommonUtils.formatTime(gankInfo.publishedAt),
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
