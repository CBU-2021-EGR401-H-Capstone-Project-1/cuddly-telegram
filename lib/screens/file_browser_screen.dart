import 'dart:math';
import 'dart:convert';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:cuddly_telegram/widgets/file_browser_screen/journal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  // Tuple fields: Title, Subtitle, Icon, Document JSON
  static const List<Tuple5<String, String, IconData, String, Color>> templates =
      [
    Tuple5(
      'Blank Journal',
      'An empty journal to start with.',
      Icons.create_rounded,
      '',
      Colors.green,
    ),
    Tuple5(
      'New Journal',
      'A journal for writing down your thoughts about your day.',
      Icons.wb_sunny_rounded,
      '[{"insert":"What I Did Today: \\nHow I Feel Today:\\nOther Comments: \\n"}]',
      Colors.blue,
    ),
    Tuple5(
      'New Bible Journal',
      'A journal for writing down notes while studying the Bible.',
      Icons.book_rounded,
      '[{"insert":"Bible Passage:\\nNotes:\\n"}]',
      Colors.amber,
    ),
    Tuple5(
      'New Class Notes',
      'A page for writing down academic notes.',
      Icons.edit_rounded,
      '[{"insert":"Subject: \\nDate: \\nNotes: \\n"}]',
      Colors.deepOrange,
    ),
    Tuple5(
      'New Task List',
      'A simple list of to-do items.',
      Icons.task_alt_rounded,
      '[{"insert":"Tasks for Today:\\nThing 1"},{"insert":"\\n","attributes":{"list":"unchecked"}},{"insert":"Thing 2"},{"insert":"\\n","attributes":{"list":"unchecked"}},{"insert":"Thing 3"},{"insert":"\\n","attributes":{"list":"unchecked"}}]',
      Colors.purple,
    ),
  ];

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

  DraggableScrollableSheet get bottomSheet {
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      expand: false,
      snap: true,
      snapSizes: const [0.9],
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Choose a Template',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: templates.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(templates[index].item1),
                    subtitle: Text(
                      templates[index].item2,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Icon(templates[index].item3,
                        color: templates[index].item5),
                    trailing: const Icon(Icons.add_rounded),
                    isThreeLine: true,
                    visualDensity: VisualDensity.comfortable,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditorScreen(
                            journal: Journal(
                                title: templates[index].item1,
                                document: templates[index].item4.isNotEmpty
                                    ? quill.Document.fromJson(
                                        jsonDecode(templates[index].item4))
                                    : quill.Document()),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      },
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
          onPressed: () => showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) => bottomSheet,
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
          bottomRight: Radius.circular(64.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary.withOpacity(0.5),
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
        child: Icon(
          Icons.add,
          color: Theme.of(context).cardColor,
        ),
        onPressed: () => showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) => bottomSheet,
        ),
      ),
    );
  }
}
