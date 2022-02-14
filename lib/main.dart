import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cuddly_telegram/model/document_store.dart';
import 'package:cuddly_telegram/model/local_style.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
import 'package:cuddly_telegram/widgets/localized_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routes = {
      FileBrowserScreen.routeName: (ctx) => const FileBrowserScreen(),
      EditorScreen.routeName: (ctx) => EditorScreen(),
    };

    return LocalizedStyle(
      child: Consumer<LocalStyle>(
        builder: (ctx, style, wdgt) {
          return ChangeNotifierProvider(
            create: (context) => DocumentStore([]),
            child: MaterialApp(
              title: 'Journal',
              theme: ThemeData.from(
                colorScheme: const ColorScheme.light().copyWith(
                  background: style.backgroundColor,
                  surface: style.backgroundColor,
                  onSecondary: style.foregroundColor,
                  onBackground: style.foregroundColor,
                  onSurface: style.foregroundColor,
                  onError: style.foregroundColor,
                ),
              ),
              routes: routes,
              initialRoute: FileBrowserScreen.routeName,
            ),
          );
        },
      ),
    );
  }
}
