// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gank_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GankInfo _$GankInfoFromJson(Map<String, dynamic> json) {
  return GankInfo(json['publishedAt'] as String, json['desc'] as String,
      json['url'] as String, json['who'] as String);
}

Map<String, dynamic> _$GankInfoToJson(GankInfo instance) => <String, dynamic>{
      'publishedAt': instance.publishedAt,
      'desc': instance.desc,
      'url': instance.url,
      'who': instance.who
    };
