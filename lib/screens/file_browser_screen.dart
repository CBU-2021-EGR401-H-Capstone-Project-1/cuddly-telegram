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
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  /// The body of the screen. A grid populated with a number of `JournalItem`
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
                    Provider.of<JournalStore>(context, listen: true)
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

  /// The app bar for the screen. A single add button creates a
  /// new journal entry and pushes to the editor screen.
  PreferredSizeWidget get appBar {
    return AppBar(
      title: const Text('Journals'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          color: Colors.white,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditorScreen(
                journal: Journal(
                  title: 'New Journal',
                  document: quill.Document(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// The drawer for the screen. This slides out from the leading
  /// side of the device, and displays links to the file browser,
  /// map, and calendar.
  Widget get drawer {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(128.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(32.0),
              ),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.inversePrimary,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: Icon(Icons.book, color: theme.colorScheme.primary),
              title: const Text('Journals'),
              onTap: () {
                navigator.pop();
              },
              selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
              selected: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(128.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: Icon(
                Icons.map,
                color: theme.colorScheme.tertiary,
              ),
              title: const Text('Map'),
              onTap: () {
                navigator.pop();
                navigator.pushNamed(MapScreen.routeName);
              },
              tileColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(128.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<JournalStore>(
        initialData: JournalStore({}),
        future: IOHelper.readJournalStore(),
        builder: (context, snapshot) {
          final journalStore =
              Provider.of<JournalStore>(context, listen: false);
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              journalStore.isEmpty) {
            journalStore.replaceAll(snapshot.data!.journals);
          }
          return body;
        },
      ),
      drawer: drawer,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditorScreen(
              journal: Journal(
                title: 'New Journal',
                document: quill.Document(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
