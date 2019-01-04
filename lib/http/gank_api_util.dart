import 'dart:convert';

import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:http/http.dart' as http;

import 'response/gank_list_res.dart';

const String _BASE_URL = "https://gank.io/api/";

Future<Map<String, dynamic>> get(String url) async {
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('get() e: $e');
  }
  return null;
}

Future<List<GankInfo>> gankList(String type, int pageNo, int pageSize) async {
  Map<String, dynamic> res =
      await get('${_BASE_URL}data/$type/$pageSize/$pageNo');
  if (null != res) {
    var gankListRes = GankListRes.fromJson(res);
    if (null != gankListRes && !gankListRes.error) {
      return gankListRes.results;
    }
  }
  return null;
}
