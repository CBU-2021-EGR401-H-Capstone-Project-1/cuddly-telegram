// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentStore _$DocumentStoreFromJson(Map<String, dynamic> json) =>
    DocumentStore(
      (json['documents'] as List<dynamic>)
          .map((e) => const _DocumentConverter().fromJson(e as List))
          .toList(),
    );

Map<String, dynamic> _$DocumentStoreToJson(DocumentStore instance) =>
    <String, dynamic>{
      'documents':
          instance.documents.map(const _DocumentConverter().toJson).toList(),
    };
