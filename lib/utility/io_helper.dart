import 'dart:convert';
import 'dart:io';

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

  static Future<File> writeDocumentStore(Map<String, dynamic> json) async {
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
    return await file.writeAsString(jsonEncode(json));
  }

  static Future<Map<String, dynamic>> readDocumentStore() async {
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
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }
}
