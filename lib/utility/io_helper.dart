import 'dart:convert';
import 'dart:io';

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cuddly_telegram/encrypt/aes_rsa_encrypt.dart';

class IOHelper {
  static final AppEncrypt encrypt = AppEncrypt();

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
  } // Create a file with .Key

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

  static Future<void> writeJournalStore(JournalStore journalStore) async {
    // TODO Encrypt file, make rsaFile and aesFile class properties
    final file = await _journalFile;
    final rsaFile = await getFile('documents', 'rsa');
    final aesFile = await getFile('documents', 'aes');
    final json = journalStore.toJson();
    final fileContents = await encrypt.encryptReadWrite(jsonEncode(json));
    await writeFile(file, fileContents.item1);
    await writeFile(rsaFile, fileContents.item2);
    await writeFile(aesFile, fileContents.item3);
  }

  static Future<JournalStore> readJournalStore() async {
    try {
      // TODO Encrypt file, make rsaFile and aesFile class properties
      final file = await _journalFile;
      final rsaFile = await getFile('documents', 'rsa');
      final aesFile = await getFile('documents', 'aes');
      final contents = await readFile(file);
      final rsa = await readFile(rsaFile);
      final aes = await readFile(aesFile);
      final decryptedContents = await encrypt.decryptReadWrite(contents, aes, rsa);
      final json = jsonDecode(decryptedContents);
      return JournalStore.fromJson(json);
    } catch (e) {
      // TODO Catch FileSystemException from file.create
      return JournalStore({});
    }
  }
}
