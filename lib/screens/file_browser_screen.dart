import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  _FileBrowserScreenState createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  Widget get body {
    final itemCount =
        Provider.of<JournalStore>(context, listen: true).journals.length;
    final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 150,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: 1 / sqrt(2), // A4 paper
    );
    return SafeArea(
      child: GridView.builder(
        gridDelegate: gridDelegate,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.amber.shade50,
            child: Consumer<JournalStore>(
              builder: ((context, journalStore, child) {
                final sortedJournals = SplayTreeSet<Journal>.from(
                  journalStore.journals,
                  (journal1, journal2) =>
                      journal1.dateCreated.compareTo(journal2.dateCreated),
                );
                final journal = sortedJournals.elementAt(index);
                return InkWell(
                  splashColor: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      EditorScreen.routeName,
                      arguments: sortedJournals.elementAt(index),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journal.title,
                          style: Theme.of(context).textTheme.labelLarge,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat.yMMMd(Platform.localeName)
                              .format(journal.dateCreated),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          journal.document.toPlainText(),
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
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
