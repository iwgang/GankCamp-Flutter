// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_day_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendDayRes _$RecommendDayResFromJson(Map<String, dynamic> json) {
  return RecommendDayRes(
      json['error'] as bool,
      (json['category'] as List)?.map((e) => e as String)?.toList(),
      (json['results'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : GankInfo.fromJson(e as Map<String, dynamic>))
              ?.toList())));
}

Map<String, dynamic> _$RecommendDayResToJson(RecommendDayRes instance) =>
    <String, dynamic>{
      'error': instance.error,
      'category': instance.category,
      'results': instance.results
    };
