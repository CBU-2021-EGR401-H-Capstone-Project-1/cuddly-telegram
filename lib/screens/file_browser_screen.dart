import 'dart:math';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:cuddly_telegram/widgets/file_browser_screen/journal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';

class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  _FileBrowserScreenState createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  /// Generates the app bar for the screen. A single add button creates a
  /// new journal entry and pushes to the editor screen.
  PreferredSizeWidget get appBar {
    return AppBar(
      title: const Text('Journals'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushNamed(
              EditorScreen.routeName,
              arguments: Journal(
                title: 'Journal',
                document: quill.Document(),
              ),
            );
          },
        )
      ],
    );
  }

  /// Generates the body of the screen. A grid populated with a number of `JournalItem`
  /// widgets equal to the number of journals in the `JournalStore` is created.
  Widget get body {
    final itemCount = Provider.of<JournalStore>(context, listen: true).count;
    final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 150,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 1 / sqrt(2), // A4 paper
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          gridDelegate: gridDelegate,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Consumer<JournalStore>(
              builder: (context, journalStore, child) {
                final sortedJournals =
                    Provider.of<JournalStore>(context, listen: false)
                        .sortedJournals;
                return JournalItem(
                  journal: sortedJournals.elementAt(index),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<JournalStore>(
        initialData: JournalStore({}),
        future: IOHelper.readJournalStore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Provider.of<JournalStore>(context, listen: false)
                .replaceAll(snapshot.data!.journals);
          }
          return body;
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Text(
                'MyJournal',
                style:
                    theme.textTheme.displaySmall!.copyWith(color: Colors.white),
              ),
              curve: Curves.bounceInOut,
            ),
            ListTile(
              leading: Icon(Icons.book, color: theme.colorScheme.secondary),
              title: const Text('Journals'),
              onTap: () {
                navigator.pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.map,
                color: theme.colorScheme.tertiary,
              ),
              title: const Text('Map'),
              onTap: () {
                navigator.pop();
                navigator.pushNamed(MapScreen.routeName);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            EditorScreen.routeName,
            arguments: Journal(
              title: 'Journal',
              document: quill.Document(),
            ),
          );
        },
      ),
    );
  }
}
