import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';
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
    this.journals.clear();
    this.journals.addAll(journals);
    print("Journals Replaced: $journals");
    // notifyListeners();
  }

  /// Adds a document to the store, writes the store to disk, and notifies all listeners.
  void add(Journal journal) {
    journals.add(journal);
    notifyListeners();
  }

  /// Removes a document from the store and notifies listeners.
  void remove(Journal journal) {
    journals.removeWhere((element) => element.id == journal.id);
    notifyListeners();
  }

  // TODO FOR DEBUGGING ONLY
  void removeAll() {
    journals.clear();
    notifyListeners();
  }

  factory JournalStore.fromJson(Map<String, dynamic> json) =>
      _$JournalStoreFromJson(json);

  Map<String, dynamic> toJson() => _$JournalStoreToJson(this);
}
