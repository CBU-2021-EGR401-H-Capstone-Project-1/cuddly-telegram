import 'dart:convert';
import 'dart:io';

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class IOHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/documents.dat');
  }

  static Future<File> writeDocumentStore(JournalStore documentStore) async {
    // TODO Encrypt file
    final file = await _localFile;
    final fileExists = await file.exists();
    if (!fileExists) {
      try {
        await file.create();
      } catch (e) {
        print(e);
      }
    }
    // encrypt
    final json = documentStore.toJson();
    return await file.writeAsString(jsonEncode(json));
  }

  static Future<JournalStore> readDocumentStore() async {
    // TODO Encrypt file
    try {
      final file = await _localFile;
      final fileExists = await file.exists();
      if (fileExists) {
        // decrypt
        final contents = await file.readAsString();
        return jsonDecode(contents);
      } else {
        await file.create();
        return JournalStore([]);
      }
    } catch (e) {
      print(e);
      return JournalStore([]);
    }
  }
}
