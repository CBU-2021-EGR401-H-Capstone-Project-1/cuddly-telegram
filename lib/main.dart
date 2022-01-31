import 'package:cuddly_telegram/screens/file_browser_screen.dart';
import 'package:flutter/material.dart';

import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:flutter_quill/models/documents/document.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routes = {
      FileBrowserScreen.routeName: (ctx) =>
          FileBrowserScreen(documents: List.filled(100, Document())),
      EditorScreen.routeName: (ctx) => EditorScreen(),
    };

    return MaterialApp(
      title: 'Journal',
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      routes: routes,
      initialRoute: FileBrowserScreen.routeName,
    );
  }
}
