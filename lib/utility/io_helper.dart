import 'dart:convert';
import 'dart:io';

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:path_provider/path_provider.dart';

class IOHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/documents.dat');
  }

  static Future<File> writeJournalStore(JournalStore journalStore) async {
    // TODO Encrypt file
    final file = await _localFile;
    final fileExists = await file.exists();
    if (!fileExists) {
      try {
        await file.create();
      } catch (e) {
        // TODO Catch FileSystemException from file.create
      }
    }
    // encrypt
    final json = journalStore.toJson();
    return await file.writeAsString(jsonEncode(json));
  }

  static Future<JournalStore> readJournalStore() async {
    // TODO Encrypt file
    try {
      final file = await _localFile;
      final fileExists = await file.exists();
      if (fileExists) {
        // decrypt
        final contents = await file.readAsString();
        final journalStore = JournalStore.fromJson(jsonDecode(contents));
        return journalStore;
      } else {
        await file.create();
        return JournalStore({});
      }
    } catch (e) {
      // TODO Catch FileSystemException from file.create
      return JournalStore({});
    }
  }
}
