import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/ui/pages/splash_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "干货集中营",
      home: SplashPage(),
    );
  }
}
