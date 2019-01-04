// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gank_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GankListRes _$GankListResFromJson(Map<String, dynamic> json) {
  return GankListRes(
      json['error'] as bool,
      (json['results'] as List)
          ?.map((e) =>
              e == null ? null : GankInfo.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$GankListResToJson(GankListRes instance) =>
    <String, dynamic>{'error': instance.error, 'results': instance.results};
