import 'package:json_annotation/json_annotation.dart';

part 'gank_info.g.dart';

@JsonSerializable()
class GankInfo {
  final String publishedAt;
  final String desc;
  final String url;
  final String who;

  GankInfo(this.publishedAt, this.desc, this.url, this.who);

  factory GankInfo.fromJson(Map<String, dynamic> json) =>
      _$GankInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GankInfoToJson(this);
}
