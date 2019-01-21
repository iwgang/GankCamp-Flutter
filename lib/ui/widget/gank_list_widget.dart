import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:gankcamp_flutter/ui/widget/refresh_common_widget.dart';
import 'package:gankcamp_flutter/constant/common_utils.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';

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
  RefreshController _refreshController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
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

  Future _onListViewLoadData(bool up) async {
    if (up) {
      // 下拉刷新
      _pageNo = 1;
      await _gankList(
          () => _refreshController.sendBack(true, RefreshStatus.completed));
    } else {
      // 加载更多
      _pageNo++;
      await _gankList(
          () => _refreshController.sendBack(false, RefreshStatus.idle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isLoading,
          child: SmartRefresher(
            enablePullUp: true,
            controller: _refreshController,
            onRefresh: _onListViewLoadData,
            headerBuilder: RefreshCommonWidget.commonHeaderBuilder,
            footerBuilder: RefreshCommonWidget.commonFooterBuilder,
            child: ListView.builder(
              itemCount: _gankInfoList?.length ?? 0,
              itemBuilder: (context, index) => InkWell(
                    child: _ItemView(_gankInfoList[index]),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final curInfo = _gankInfoList[index];
                          return WebViewPage(curInfo.desc, curInfo.url);
                        }),
                      );
                    },
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
