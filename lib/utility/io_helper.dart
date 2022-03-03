import 'dart:convert';
import 'dart:io';

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:path_provider/path_provider.dart';

class IOHelper {
  /// Returns the local application's documents directory for the device.
  /// On Android, this uses the `getDataDirectory` API.
  /// On iOS, this uses the `NSDocumentDirectory` API.
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the local journal store File.
  static Future<File> get _journalFile async {
    return await getFile('documents', 'dat');
  }

  /// Returns a File with the given name and file extension.
  static Future<File> getFile(String name, String fileExt) async {
    final path = await _localPath;
    return File('$path/$name.$fileExt');
  }

  static Future<File> writeFile(File file, String contents) async {
    if (!await file.exists()) {
      try {
        await file.create();
      } catch (e) {
        rethrow; // TODO Handle exception
      }
    }
    return await file.writeAsString(contents);
  }

  static Future<String> readFile(File file) async {
    if (!await file.exists()) {
      return Future.error(
        FileSystemException("File $file does not exist!", file.path),
      );
    }
    return await file.readAsString();
  }

  static Future<File> writeJournalStore(JournalStore journalStore) async {
    // TODO Encrypt file
    final file = await _journalFile;
    final json = journalStore.toJson();
    return await writeFile(file, jsonEncode(json));
  }

  static Future<JournalStore> readJournalStore() async {
    // TODO Encrypt file
    try {
      final file = await _journalFile;
      final contents = await readFile(file);
      final json = jsonDecode(contents);
      return JournalStore.fromJson(json);
    } catch (e) {
      // TODO Catch FileSystemException from file.create
      return JournalStore({});
    }
  }
}
