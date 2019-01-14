import 'package:dio/dio.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';

import 'response/gank_list_res.dart';

class GankApiManager {
  static Dio dio = Dio();

  static const _BASE_URL = "https://gank.io/api/";

  static Future<Map<String, dynamic>> get(String url) async {
    try {
      print('>>> get url = $url');
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('get() e: $e');
    }
    return null;
  }

  static Future<List<GankInfo>> gankList(
      String type, int pageNo, int pageSize) async {
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
}
