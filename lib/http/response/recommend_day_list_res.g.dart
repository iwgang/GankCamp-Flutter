// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_day_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendDayListRes _$RecommendDayListResFromJson(Map<String, dynamic> json) {
  return RecommendDayListRes(json['error'] as bool,
      (json['results'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$RecommendDayListResToJson(
        RecommendDayListRes instance) =>
    <String, dynamic>{'error': instance.error, 'results': instance.results};
