import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:gankcamp_flutter/ui/pages/show_picture_page.dart';
import 'package:gankcamp_flutter/ui/widget/refresh_common_widget.dart';

class MainTabGirlWidget extends StatefulWidget {
  @override
  State createState() => _MainTabGirlState();
}

class _MainTabGirlState extends State<MainTabGirlWidget>
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

  Future<Null> _onRefresh() async {
    _pageNo = 1;
    await _girlList();
  }

  Future _onLoadMore() async {
    _pageNo++;
    await _girlList();
  }

  List<Widget> _buildItem(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    var slivers = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: (orientation == Orientation.portrait) ? 0.8 : 0.9,
      ),
      padding: const EdgeInsets.all(4),
      itemCount: _itemCount(),
      itemBuilder: (context, index) => _ItemView(_gankInfoList[index]),
    ).buildSlivers(context);
    slivers.add(SliverToBoxAdapter(
      child: RefreshCommonWidget.commonLoadMoreWidget(),
    ));
    return slivers;
  }

  int _itemCount() => _gankInfoList?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            child: RefreshIndicator(
              color: AppColors.MAIN_COLOR,
              onRefresh: _onRefresh,
              child: Scrollbar(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: _buildItem(context),
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
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: GridTile(
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
                placeholder: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.MAIN_COLOR),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Color(0x20000000),
              splashColor: Color(0x103f3f3f),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowPicturePage(gankInfo.url),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
