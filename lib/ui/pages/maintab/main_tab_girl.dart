import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:gankcamp_flutter/ui/widget/refresh_common_widget.dart';
import 'package:gankcamp_flutter/ui/pages/show_picture_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainTabGirlWidget extends StatefulWidget {
  @override
  State createState() => _MainTabGirlState();
}

class _MainTabGirlState extends State<MainTabGirlWidget>
    with AutomaticKeepAliveClientMixin {
  List<GankInfo> _gankInfoList;
  RefreshController _refreshController;
  int _pageNo = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _girlList(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _girlList([VoidCallback loadEndCallback]) async {
    List<GankInfo> res = await GankApiManager.gankList('福利', _pageNo, 10);
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
      await _girlList(
          () => _refreshController.sendBack(true, RefreshStatus.completed));
    } else {
      // 加载更多
      _pageNo++;
      await _girlList(
          () => _refreshController.sendBack(false, RefreshStatus.idle));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('妹纸'),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading,
            child: SmartRefresher(
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: _onListViewLoadData,
              headerBuilder: RefreshCommonWidget.commonHeaderBuilder,
              footerBuilder: RefreshCommonWidget.commonFooterBuilder,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.all(4),
                childAspectRatio:
                    (orientation == Orientation.portrait) ? 0.8 : 0.9,
                children: null != _gankInfoList
                    ? _gankInfoList
                        .map<Widget>((info) => InkWell(
                              child: _ItemView(info),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShowPicturePage(info.url),
                                  ),
                                );
                              },
                            ))
                        .toList()
                    : <Widget>[],
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

  @override
  bool get wantKeepAlive => true;
}

class _ItemView extends StatelessWidget {
  final GankInfo gankInfo;

  _ItemView(this.gankInfo);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Container(
        color: Color(0x60000000),
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
        child: Text(
          'via：${gankInfo.who}',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
      child: Container(
        color: Color(0xffe0e0e0),
        child: CachedNetworkImage(
          imageUrl: gankInfo.url,
          placeholder: CircularProgressIndicator(
            backgroundColor: AppColors.MAIN_COLOR,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
