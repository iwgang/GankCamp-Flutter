import 'package:dio/dio.dart';
import 'package:gankcamp_flutter/model/gank_info.dart';

import 'response/gank_list_res.dart';
import 'response/recommend_day_list_res.dart';
import 'response/recommend_day_res.dart';

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

  static Future<List<GankInfo>> gankList(String type, int pageNo,
      int pageSize) async {
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

  static Future<RecommendDayRes> recommendDay(String date) async {
    Map<String, dynamic> res = await get('${_BASE_URL}day/$date');
    if (null != res) return RecommendDayRes.fromJson(res);
    return null;
  }

  static Future<List<String>> recommendDayList() async {
    Map<String, dynamic> oriRes = await get('${_BASE_URL}day/history');
    if (null != oriRes) {
      var res = RecommendDayListRes.fromJson(oriRes);
      if (null != res && !res.error) {
        return res.results;
      }
    }
    return null;
  }

  static Future<bool> pushGank(String title, String who, String url,
      String type) async {
    FormData formData = new FormData.from({
    'desc': title,
    'who': who,
    'url': url,
    'type': type,
    'debug': 'true',
    });
    final response = await dio.post('${_BASE_URL}add2gank', data: formData);
    print('response.statusCode = ${response.statusCode}');
    if (response.statusCode == 200) {
      print('response.data = ${response.data}');
      return true;
    }
    return false;
  }
}
