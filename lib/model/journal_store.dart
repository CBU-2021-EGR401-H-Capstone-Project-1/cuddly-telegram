import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_store.g.dart';

@JsonSerializable()
class JournalStore extends ChangeNotifier {
  JournalStore(this.journals);

  /// An internal store of the journals. Do not modify this directly.
  final Set<Journal> journals;

  /// The number of journals in the store.
  int get count {
    return journals.length;
  }

  /// Replaces all of the current journals with a new list of journals.
  /// This is primarily used for updating the journal store after an IO read.
  void replaceAll(Set<Journal> journals) {
    this.journals.clear();
    this.journals.addAll(journals);
    print("Journals Replaced: $journals");
    // notifyListeners();
  }

  /// Adds a journal to the store, writes the store to disk, and notifies all listeners.
  void add(Journal journal) {
    journals.add(journal);
    notifyListeners();
  }

  /// Removes a journal from the store and notifies listeners.
  void remove(Journal journal) {
    journals.removeWhere((element) => element.id == journal.id);
    notifyListeners();
  }

  /// Replaces a journal in the store with one that has a matching ID.
  void update(Journal journal) {
    journals.removeWhere((element) => element.id == journal.id);
    journals.add(journal);
    notifyListeners();
  }

  factory JournalStore.fromJson(Map<String, dynamic> json) =>
      _$JournalStoreFromJson(json);

  Map<String, dynamic> toJson() => _$JournalStoreToJson(this);
}
