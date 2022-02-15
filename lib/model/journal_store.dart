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

  /// Whether or not the store is empty.
  bool get isEmpty {
    return journals.isEmpty;
  }

  /// Whether or not the store is not empty.
  bool get isNotEmpty {
    return journals.isNotEmpty;
  }

  Journal journalWithId(String id) {
    return journals.firstWhere((element) => element.id == id);
  }

  /// Returns an unmodifiable sorted set of all the journals in the store.
  /// The journals are sorted by date created.
  UnmodifiableSetView<Journal> get sortedJournals {
    return UnmodifiableSetView(SplayTreeSet.from(journals,
        ((key1, key2) => key1.dateCreated.compareTo(key2.dateCreated))));
  }

  /// Replaces all of the current journals with a new list of journals.
  /// This is primarily used for updating the journal store after an IO read.
  void replaceAll(Set<Journal> journals) {
    this.journals.clear();
    this.journals.addAll(journals);
  }

  /// If a matching journal exists in the store already, it is replaced
  /// with the newer given journal. If one doesn't exist, then it is added
  /// to the store.
  void save(Journal journal) {
    try {
      final matchingJournal =
          journals.firstWhere((element) => element.id == journal.id);
      if (journals.remove(matchingJournal)) {
        journals.add(journal);
      }
      for (journal in journals) {
        print(journal);
      }
      notifyListeners();
    } catch (error) {
      journals.add(journal);
      notifyListeners();
    }
    notifyListeners();
  }

  /// Removes a journal from the store and notifies listeners.
  void remove(Journal journal) {
    journals.removeWhere((element) => element.id == journal.id);
    notifyListeners();
  }

  /// Creates a JournalStore from a Map of JSON.
  factory JournalStore.fromJson(Map<String, dynamic> json) =>
      _$JournalStoreFromJson(json);

  /// Creates a Map of JSON from a JournalStore.
  Map<String, dynamic> toJson() => _$JournalStoreToJson(this);

  @override
  String toString() {
    return 'JournalStore\nJournals: $journals';
  }
}
