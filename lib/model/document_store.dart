import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:json_annotation/json_annotation.dart';

part 'document_store.g.dart';

@JsonSerializable()
@_DocumentConverter()
class DocumentStore extends ChangeNotifier {
  DocumentStore(this.documents);

  /// An internal store of the documents. Do not modify this directly.
  final List<quill.Document> documents;

  /// The number of documents in the store.
  int get count {
    return documents.length;
  }

  /// Adds a document to the store, writes the store to disk, and notifies all listeners.
  void add(quill.Document document) {
    documents.add(document);
    notifyListeners();
  }

  /// Removes a document from the store. If the removal was successful, then
  /// the store is written to disk, listeners are notified, and `true` is returned.
  /// If the removal fails, then `false` is returned.
  bool remove(quill.Document document) {
    final success = documents.remove(document);
    if (success) notifyListeners();
    return success;
  }

  factory DocumentStore.fromJson(Map<String, dynamic> json) =>
      _$DocumentStoreFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentStoreToJson(this);
}

class _DocumentConverter
    implements JsonConverter<quill.Document, List<dynamic>> {
  const _DocumentConverter();

  @override
  quill.Document fromJson(List<dynamic> json) => quill.Document.fromJson(json);

  @override
  List<dynamic> toJson(quill.Document document) => document.toDelta().toJson();
}
