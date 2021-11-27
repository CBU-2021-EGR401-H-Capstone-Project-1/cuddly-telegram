import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

    return Platform.isIOS
        ? CupertinoApp(
            title: 'Journal',
            theme: CupertinoThemeData(
              barBackgroundColor: Colors.teal[100],
              brightness: Brightness.light,
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.white,
              scaffoldBackgroundColor: Colors.grey[200],
            ),
            routes: routes,
            initialRoute: EditorScreen.routeName,
          )
        : MaterialApp(
            title: 'Journal',
            theme: ThemeData.from(colorScheme: const ColorScheme.light()),
            routes: routes,
            initialRoute: EditorScreen.routeName,
          );
  }
}
