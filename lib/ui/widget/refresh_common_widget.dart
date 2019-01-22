import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';

class RefreshCommonWidget {
  static Widget commonLoadMoreWidget() => Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingFour(
              color: AppColors.MAIN_COLOR,
              size: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                '加载更多',
                style: TextStyle(color: Color(0xff999999)),
              ),
            )
          ],
        ),
      );
}
