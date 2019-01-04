import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gank_list_res.g.dart';

@JsonSerializable()
class GankListRes {
  final bool error;
  final List<GankInfo> results;

  GankListRes(this.error, this.results);

  factory GankListRes.fromJson(Map<String, dynamic> json) =>
      _$GankListResFromJson(json);

  Map<String, dynamic> toJson() => _$GankListResToJson(this);
}
