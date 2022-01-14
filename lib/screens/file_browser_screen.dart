import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({Key? key, required this.documents})
      : super(key: key);

  static const routeName = "/";

  final List<quill.Document> documents;

  @override
  _FileBrowserScreenState createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  Widget get body {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.documents.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).pushNamed(EditorScreen.routeName);
            },
            child: Center(
              child: Text("Document"),
            ),
          ),
          color: Colors.yellow.shade100,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
