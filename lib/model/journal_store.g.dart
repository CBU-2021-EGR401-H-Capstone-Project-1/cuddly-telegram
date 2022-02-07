// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalStore _$JournalStoreFromJson(Map<String, dynamic> json) => JournalStore(
      (json['journals'] as List<dynamic>)
          .map((e) => Journal.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$JournalStoreToJson(JournalStore instance) =>
    <String, dynamic>{
      'journals': instance.journals.toList(),
    };
