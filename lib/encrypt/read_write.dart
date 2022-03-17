import 'dart:io';

class ReadWrite {
  dynamic userFile(dynamic path) {
    return path;
  }

  Future<dynamic> writeCounter(dynamic path, dynamic whatToWrite) async {
    // Write the file
    return await File(path).writeAsString('$whatToWrite');
  }

  Future<dynamic> testReading(dynamic path) async {
    final String readLines;
    dynamic test = ReadWrite().userFile('$path');
    final file = File(test);
    readLines = await file.readAsString();
    return readLines;
  }
}


