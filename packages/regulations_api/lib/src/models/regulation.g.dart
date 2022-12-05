// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Regulation _$RegulationFromJson(Map<String, dynamic> json) => Regulation(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$RegulationToJson(Regulation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
    };
