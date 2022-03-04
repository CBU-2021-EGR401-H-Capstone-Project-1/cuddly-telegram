// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journal _$JournalFromJson(Map<String, dynamic> json) => Journal(
      title: json['title'] as String,
      document:
          const _QuillDocumentConverter().fromJson(json['document'] as List),
    )
      ..id = json['id'] as String
      ..dateCreated = DateTime.parse(json['dateCreated'] as String)
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..passwordHash = json['passwordHash'] as String?;

Map<String, dynamic> _$JournalToJson(Journal instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'document': const _QuillDocumentConverter().toJson(instance.document),
      'dateCreated': instance.dateCreated.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'passwordHash': instance.passwordHash,
    };
