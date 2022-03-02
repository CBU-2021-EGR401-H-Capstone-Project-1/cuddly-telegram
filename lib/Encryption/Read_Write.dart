import 'dart:convert';
import 'dart:io';


class Read_Write{

dynamic userFile(dynamic path){
  return path;
}

Future<dynamic> writeCounter(dynamic path, dynamic whatToWrite) async {
  // Write the file
  return await File(path).writeAsString('$whatToWrite');
}

Future<dynamic> testReading(dynamic path) async {
  final readLines;
  dynamic  test = Read_Write().userFile('$path');
  final file = File(test);
  readLines = await file.readAsString();
  return readLines;
}
}
// main()async {
//   try {
//     var path = '/Users/ladmin/Desktop/hello.txt';
//     Read_Write().userFile(path);
//     var readLines = await testReading(path);
//     String test = "FUCK DART";
//     await Read_Write().writeCounter(path, test);
//     var readLines2 = await testReading(path);
//     print(readLines2);
//   } catch (e){
//     return 0;
//   }
// }

