import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/ui/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _gankIoController;
  CurvedAnimation _gankIoCurve;

  AnimationController _desc1Controller;
  Animation<double> _desc1Anim;
  CurvedAnimation _desc1Curve;

  AnimationController _desc2Controller;
  Animation<double> _desc2Anim;
  CurvedAnimation _desc2Curve;

  @override
  void initState() {
    super.initState();
    _gankIoController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _gankIoCurve = CurvedAnimation(
      parent: _gankIoController,
      curve: Curves.easeInOut,
    );

    _desc1Controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _desc1Curve = CurvedAnimation(
      parent: _desc1Controller,
      curve: Curves.easeInOut,
    );
    _desc1Anim = Tween(begin: 200.0, end: 0.0).animate(_desc1Controller)
      ..addListener(() {
        setState(() {});
      });

    _desc2Controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _desc2Curve = CurvedAnimation(
      parent: _desc2Controller,
      curve: Curves.easeInOut,
    );
    _desc2Anim = Tween(begin: 200.0, end: 0.0).animate(_desc2Controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          });
        }
      });

    _gankIoController.forward();
    _desc1Controller.forward();
    _desc2Controller.forward();
  }

  @override
  void dispose() {
    _gankIoController.dispose();
    _desc1Controller.dispose();
    _desc2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.MAIN_COLOR,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _gankIoCurve,
              child: Text(
                'Gank.io',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FadeTransition(
              opacity: _desc1Curve,
              child: Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: _desc1Anim == null ? 0.0 : _desc1Anim?.value,
                ),
                child: Text(
                  '干货集中营',
                  style: TextStyle(
                    color: Color(0xffD3D3D3),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: _desc2Curve,
              child: Container(
                margin: EdgeInsets.only(
                  top: 30,
                  right: _desc2Anim == null ? 0.0 : _desc2Anim?.value,
                ),
                child: Text(
                  '每日分享妹子图和技术干货',
                  style: TextStyle(
                    color: Color(0xffD3D3D3),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
