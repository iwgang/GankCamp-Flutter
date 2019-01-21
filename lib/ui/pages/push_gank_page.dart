import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gankcamp_flutter/constant/app_colors.dart';
import 'package:gankcamp_flutter/http/gank_api_manager.dart';

class PushGankPage extends StatefulWidget {
  @override
  State createState() => _PushGankPageState();
}

class _PushGankPageState extends State<PushGankPage> {
  final List<String> _types = <String>[
    'Android',
    'iOS',
    '休息视频',
    '福利',
    '拓展资源',
    '前端',
    '瞎推荐',
    'App'
  ];
  String _selType = 'Android';
  TextEditingController _titleController;
  TextEditingController _whoController;
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _whoController = TextEditingController();
    _urlController = TextEditingController();
  }

  void _checkAndPushGank() {
    final title = _titleController.text;
    final who = _whoController.text;
    final url = _urlController.text;

    if (title.length == 0) {
      Fluttertoast.showToast(msg: '请输入标题');
      return;
    }

    if (who.length == 0) {
      Fluttertoast.showToast(msg: '请输入提交者');
      return;
    }

    if (url.length == 0) {
      Fluttertoast.showToast(msg: '请输入url');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    _pushGank(title, who, url, _selType);
  }

  void _pushGank(String title, String who, String url, String type) async {
    final res = await GankApiManager.pushGank(title, who, url, type);
    Navigator.of(context).pop();
    if (null != res) {
      if (res.error) {
        Fluttertoast.showToast(msg: res.msg ?? '提交失败，请重试');
      } else {
        Fluttertoast.showToast(msg: '提交成功');
        _titleController.clear();
        _whoController.clear();
        _urlController.clear();
      }
    } else {
      Fluttertoast.showToast(msg: '提交失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提交干货'),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 2,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
              ),
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: '标题',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _whoController,
                    decoration: InputDecoration(
                      labelText: '提交者',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'URL',
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '选择类型',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xff666666),
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selType,
                          onChanged: (String newValue) {
                            setState(() {
                              _selType = newValue;
                            });
                          },
                          items: _types
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25, right: 25),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                backgroundColor: AppColors.MAIN_COLOR,
                child: Icon(Icons.arrow_forward),
                onPressed: _checkAndPushGank,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
