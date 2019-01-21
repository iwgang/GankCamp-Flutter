import 'package:flutter/material.dart';
import 'package:gankcamp_flutter/database/collection_db_manager.dart';

class CollectionInfo {
  int id;
  String title;
  String url;
  String time;

  CollectionInfo(
      {@required this.title, @required this.url, this.time, this.id});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      COLUMN_TITLE: title,
      COLUMN_URL: url,
      COLUMN_TIME: time,
    };
    if (id != null) {
      map[COLUMN_ID] = id;
    }
    return map;
  }

  CollectionInfo.fromMap(Map<String, dynamic> map) {
    id = map[COLUMN_ID];
    title = map[COLUMN_TITLE];
    url = map[COLUMN_URL];
    time = map[COLUMN_TIME];
  }
}
