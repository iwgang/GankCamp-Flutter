import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:photo_view/photo_view.dart';

class ShowPicturePage extends StatelessWidget {
  final String pictureUrl;

  ShowPicturePage(this.pictureUrl);

  void _saveImage() async {
    final res = await http.get(pictureUrl);
    ImagePickerSaver.saveFile(fileData: res.bodyBytes).then((filePath) {
      Fluttertoast.showToast(
        msg: "保存成功，图片位置：$filePath",
        toastLength: Toast.LENGTH_LONG,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PhotoView(
              imageProvider: NetworkImage(pictureUrl),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 30),
            child: IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () async => _saveImage(),
            ),
          ),
        ],
      ),
    );
  }
}
