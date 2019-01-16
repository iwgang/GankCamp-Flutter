import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowPicturePage extends StatelessWidget {
  final String pictureUrl;

  ShowPicturePage(this.pictureUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(pictureUrl),
      ),
    );
  }
}
