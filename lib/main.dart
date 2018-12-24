import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '干货集中营',
      home: Scaffold(
        appBar: AppBar(
          title: Text('干货'),
        ),
        body: Center(
          child: RollingButton(),
        ),
      ),
    );
  }
}

class RollingButton extends StatefulWidget {
  @override
  State createState() => _RollingState();
}

class _RollingState extends State<RollingButton> {
  final _random = Random();

  List<int> _roll() {
    final roll1 = _random.nextInt(6) + 1;
    final roll2 = _random.nextInt(6) + 1;
    return [roll1, roll2];
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('点我试试'),
      onPressed: _onPressed,
    );
  }

  void _onPressed() {
    print('点我干啥阿...$context');
    final rollResult = _roll();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('我是标题吖'),
          content: Text('点我干啥吖...${rollResult[0]} _ ${rollResult[1]}'),
        );
      },
    );
  }
}
