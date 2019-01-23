import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/http/response/recommend_day_res.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:gankcamp_flutter/ui/pages/show_picture_page.dart';
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';
import 'package:gankcamp_flutter/ui/widget/select_rec_date_widget.dart';

class MainTabRecWidget extends StatefulWidget {
  @override
  State createState() => _MainTabState();
}

class _MainTabState extends State<MainTabRecWidget>
    with AutomaticKeepAliveClientMixin {
  final double _appBarHeight = 280;
  RecommendDayRes _recommendDayRes;
  List<String> _canSelRecDateList;
  String _bannerUrl;
  bool _isLoading = true;
  String _recDate;

  @override
  void initState() {
    super.initState();
    _getRecDateList();
  }

  Future _getRecDateList() async {
    List<String> res = await GankApiManager.recommendDayList();
    if (null != res && res.isNotEmpty) {
      _canSelRecDateList = res;
      _recommendDay(_canSelRecDateList[0]);
    }
  }

  Future _recommendDay(String date) async {
    setState(() {
      _recDate = date;
    });
    RecommendDayRes res =
        await GankApiManager.recommendDay(date.replaceAll('-', '/'));
    if (null != res) {
      final welfareKey = '福利';
      if (res.results.containsKey(welfareKey)) {
        setState(() {
          _bannerUrl = res.results[welfareKey][0].url;
        });
        res.results.remove(welfareKey);
        res.category.remove(welfareKey);
      }
      res.category.sort((a, b) => a.compareTo(b));
      setState(() {
        _recommendDayRes = res;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isLoading,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: AppColors.MAIN_COLOR,
                expandedHeight: _appBarHeight,
                pinned: true,
                title: Text('推荐：$_recDate'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.date_range),
                    tooltip: '切换日期',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SelectRecDateWidget(_canSelRecDateList,
                                (String date) {
                              setState(() {
                                _isLoading = true;
                              });
                              _recommendDay(date.replaceAll('-', '/'));
                            }),
                      );
                    },
                  ),
                ],
                flexibleSpace: null == _bannerUrl
                    ? null
                    : FlexibleSpaceBar(
                        background: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: _bannerUrl,
                                fit: BoxFit.cover,
                                height: _appBarHeight,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Color(0x15000000),
                                  splashColor: Color(0x103f3f3f),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShowPicturePage(_bannerUrl),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(bodyWidgets()),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !_isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text('推荐'),
              backgroundColor: AppColors.MAIN_COLOR,
              elevation: 2,
            ),
            body: Center(
              child: SpinKitThreeBounce(
                color: AppColors.MAIN_COLOR,
                size: 30.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> bodyWidgets() {
    var retList = <Widget>[];
    if (null != _recommendDayRes) {
      _recommendDayRes.category.forEach((category) {
        retList.add(
            buildCategoryWidget(category, _recommendDayRes.results[category]));
      });
    }
    retList.add(SizedBox(height: 30));
    return retList;
  }

  Widget buildCategoryWidget(String category, List<GankInfo> gankInfoList) {
    var contentList = <Widget>[];
    contentList.add(Container(
      margin: EdgeInsets.only(top: 27, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            category,
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7, right: 10),
            child: Divider(
              color: Colors.black,
              height: 2,
            ),
          ),
        ],
      ),
    ));

    gankInfoList.forEach((gankInfo) {
      contentList.add(Container(
        margin: EdgeInsets.only(top: 13),
        padding: EdgeInsets.only(left: 15, right: 10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WebViewPage(gankInfo.desc, gankInfo.url),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '•',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xff333333),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 15),
                  child: Text(
                    gankInfo.desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff333333),
                    ),
                  ),
                ),
              ),
              Text(
                gankInfo.who,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff999999),
                ),
              ),
            ],
          ),
        ),
      ));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentList,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
