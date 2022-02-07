import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:json_annotation/json_annotation.dart';

part 'journal_store.g.dart';

@JsonSerializable()
class JournalStore extends ChangeNotifier {
  JournalStore(this.journals);

  /// An internal store of the documents. Do not modify this directly.
  final Set<Journal> journals;

  /// The number of documents in the store.
  int get count {
    return journals.length;
  }

  /// Replaces all of the current documents with a new list of documents.
  /// This is primarily used for updating the document store after an IO read.
  void replaceAll(Set<Journal> journals) {
    journals.clear();
    journals.addAll(journals);
  }

  /// Adds a document to the store, writes the store to disk, and notifies all listeners.
  void add(Journal journal) {
    journals.add(journal);
    notifyListeners();
  }

  /// Removes a document from the store. If the removal was successful, then
  /// the store is written to disk, listeners are notified, and `true` is returned.
  /// If the removal fails, then `false` is returned.
  bool remove(Journal journal) {
    final success = journals.remove(journal);
    if (success) notifyListeners();
    return success;
  }

  factory JournalStore.fromJson(Map<String, dynamic> json) =>
      _$JournalStoreFromJson(json);

  Map<String, dynamic> toJson() => _$JournalStoreToJson(this);
}
