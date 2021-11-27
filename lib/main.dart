import 'package:flutter/material.dart';

import 'package:cuddly_telegram/screens/editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routes = {
      EditorScreen.routeName: (ctx) => EditorScreen(),
    };

    return MaterialApp(
      title: 'Journal',
      theme: ThemeData.from(colorScheme: const ColorScheme.light()),
      routes: routes,
      initialRoute: EditorScreen.routeName,
    );
  }
}
