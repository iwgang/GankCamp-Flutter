import 'package:gankcamp_flutter/model/gank_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommend_day_res.g.dart';

@JsonSerializable()
class RecommendDayRes {
  final bool error;
  final List<String> category;
  final Map<String, List<GankInfo>> results;

  RecommendDayRes(this.error, this.category, this.results);

  factory RecommendDayRes.fromJson(Map<String, dynamic> json) =>
      _$RecommendDayResFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendDayResToJson(this);
}
