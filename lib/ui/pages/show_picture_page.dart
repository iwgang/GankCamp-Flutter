import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/cupertino.dart';

class ShowPicturePage extends StatelessWidget {
  final String pictureUrl;

  ShowPicturePage(this.pictureUrl);

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
        ],
      ),
    );
  }
}
