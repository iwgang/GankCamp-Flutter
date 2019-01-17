import 'package:json_annotation/json_annotation.dart';

part 'recommend_day_list_res.g.dart';

@JsonSerializable()
class RecommendDayListRes {
  final bool error;
  final List<String> results;

  RecommendDayListRes(this.error, this.results);

  factory RecommendDayListRes.fromJson(Map<String, dynamic> json) =>
      _$RecommendDayListResFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendDayListResToJson(this);
}
