import 'dart:collection';

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

  UnmodifiableSetView<Journal> get sortedJournals {
    return UnmodifiableSetView(
      SplayTreeSet<Journal>.from(
        journals,
        (journal1, journal2) =>
            journal1.dateCreated.compareTo(journal2.dateCreated),
      ),
    );
  }

  /// Replaces all of the current journals with a new list of journals.
  /// This is primarily used for updating the journal store after an IO read.
  void replaceAll(Set<Journal> journals) {
    this.journals.clear();
    this.journals.addAll(journals);
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

  /// Creates a JournalStore from a Map of JSON.
  factory JournalStore.fromJson(Map<String, dynamic> json) =>
      _$JournalStoreFromJson(json);

  /// Creates a Map of JSON from a JournalStore.
  Map<String, dynamic> toJson() => _$JournalStoreToJson(this);
}
