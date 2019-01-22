import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:gankcamp_flutter/ui/widget/refresh_common_widget.dart';
import 'package:gankcamp_flutter/constant/common_utils.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:gankcamp_flutter/ui/pages/webview_page.dart';

class RefreshWidget extends StatefulWidget {
  final ScrollView child;

  RefreshWidget({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  State createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position;
      if (scrollPosition.pixels == scrollPosition.maxScrollExtent) {
        print('滚动到底部了...');
      }
    });
  }

  Future<Null> _onRefresh() async {
    print('_onRefresh >>>');
    return Future.delayed(Duration(seconds: 2), () => null);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child: widget.child, onRefresh: _onRefresh);
  }
}
