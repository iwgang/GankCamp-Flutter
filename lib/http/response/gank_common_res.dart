import 'package:json_annotation/json_annotation.dart';

part 'gank_common_res.g.dart';

@JsonSerializable()
class GankCommonRes {
  final bool error;
  final String msg;

  GankCommonRes(this.error, this.msg);

  factory GankCommonRes.fromJson(Map<String, dynamic> json) =>
      _$GankCommonResFromJson(json);

  Map<String, dynamic> toJson() => _$GankCommonResToJson(this);
}
