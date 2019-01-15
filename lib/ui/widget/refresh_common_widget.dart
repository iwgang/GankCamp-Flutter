import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class RefreshCommonWidget {
  static Indicator commonHeaderBuilder(_, int mode) => ClassicIndicator(
        mode: mode,
        failedText: '刷新失败',
        completeText: '已刷新',
        releaseText: '松开刷新',
        idleText: '下拉刷新',
        refreshingText: '正在刷新...',
        failedIcon: new Icon(Icons.sms_failed, color: Colors.black),
        completeIcon: new Icon(Icons.done, color: Colors.black),
        idleIcon: new Icon(Icons.arrow_downward, color: Colors.black),
        releaseIcon: new Icon(Icons.arrow_upward, color: Colors.black),
      );

  static Indicator commonFooterBuilder(_, int mode) => ClassicIndicator(
        mode: mode,
        idleIcon: Icon(Icons.refresh, color: Colors.black),
        refreshingText: '正在加载中...',
        idleText: '上拉加载',
        failedText: '网络异常',
        noDataText: '没有更多数据了',
      );
}
