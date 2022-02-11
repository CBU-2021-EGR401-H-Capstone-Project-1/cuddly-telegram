import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routes = {
      FileBrowserScreen.routeName: (ctx) => const FileBrowserScreen(),
      EditorScreen.routeName: (ctx) => const EditorScreen(),
      MapScreen.routeName: (ctx) => const MapScreen(),
    };

    return ChangeNotifierProvider(
      create: (context) => JournalStore({}),
      child: MaterialApp(
        title: 'Journal',
        theme: ThemeData.from(colorScheme: const ColorScheme.light()),
        routes: routes,
        initialRoute: FileBrowserScreen.routeName,
      ),
    );
  }
}
