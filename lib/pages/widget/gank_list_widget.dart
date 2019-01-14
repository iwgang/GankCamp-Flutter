import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:gankcamp_flutter/pages/widget/refresh_common_widget.dart';

typedef OnItemClickListener = void Function(int position);

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

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _gankList();
  }

  Future _gankList([VoidCallback loadEndCallback = ]) async {
    print('加载 _pageNo = $_pageNo _____ $loadEndCallback');
    List<GankInfo> res =
        await GankApiManager.gankList(widget.type, _pageNo, 20);
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
    return Container(
      color: Colors.white,
      child: SmartRefresher(
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onListViewLoadData,
        headerBuilder: RefreshCommonWidget.commonHeaderBuilder,
        footerBuilder: RefreshCommonWidget.commonFooterBuilder,
        child: ListView.builder(
          itemCount: _gankInfoList?.length ?? 0,
          itemBuilder: (context, index) => InkWell(
                child: _ItemView(index, _gankInfoList[index]),
                onTap: () => print('All listener'),
              ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemView extends StatelessWidget {
  final int pos;
  final GankInfo gankInfo;

  _ItemView(this.pos, this.gankInfo);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(25),
          child: Icon(Icons.restaurant, color: Colors.blue),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(gankInfo.desc),
              Text(gankInfo.who),
            ],
          ),
        )
      ],
    );
  }
}
