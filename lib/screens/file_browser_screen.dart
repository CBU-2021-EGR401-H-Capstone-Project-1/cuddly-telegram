import 'dart:math';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
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
  Widget get body {
    return SafeArea(
      child: Consumer<JournalStore>(
        builder: (context, journalStore, child) => GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1 / sqrt(2), // A4 paper
          ),
          itemCount: journalStore.count,
          itemBuilder: (BuildContext ctx, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    EditorScreen.routeName,
                    arguments: journalStore.journals.elementAt(index),
                  );
                },
                child: Center(
                  child: Text(journalStore.journals.elementAt(index).title),
                ),
              ),
              color: Colors.yellow.shade100,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: FutureBuilder<JournalStore>(
        initialData: JournalStore({}),
        future: IOHelper.readJournalStore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Provider.of<JournalStore>(context, listen: true)
                .replaceAll(snapshot.data!.journals);
            print("JournalStore updated from snapshot.");
          }
          return body;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditorScreen.routeName,
              arguments: Journal(title: "Journal", document: quill.Document()));
        },
      ),
    );
  }
}
