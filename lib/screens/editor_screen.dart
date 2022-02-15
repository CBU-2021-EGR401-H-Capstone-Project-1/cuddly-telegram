import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:cuddly_telegram/widgets/editor_screen/edit_title_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, required this.journal}) : super(key: key);
  final Journal journal;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final FocusNode _focusNode = FocusNode();

  void onDropdownSelect(String? newValue, BuildContext context) {
    switch (newValue) {
      case 'save':
        print(widget.journal);
        Provider.of<JournalStore>(context, listen: false).save(widget.journal);
        IOHelper.writeJournalStore(
            Provider.of<JournalStore>(context, listen: false));
        break;
      case 'delete':
        Provider.of<JournalStore>(context, listen: false)
            .remove(widget.journal);
        IOHelper.writeJournalStore(
            Provider.of<JournalStore>(context, listen: false));
        Navigator.of(context).pop();
        break;
      case 'editTitle':
        showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) {
            return EditTitleAlertDialog(
              journal: widget.journal,
              onSavePressed: (newTitle) {
                setState(() {
                  widget.journal.title = newTitle;
                });
                final journalStore =
                    Provider.of<JournalStore>(context, listen: false);
                journalStore.save(widget.journal);
                IOHelper.writeJournalStore(journalStore);
              },
            );
          },
        );
        break;
      case 'setLocation':
        LatLng? currentLocation;
        print("Pre Set-Location: ${widget.journal}");
        if (widget.journal.latitude != null &&
            widget.journal.longitude != null) {
          currentLocation =
              LatLng(widget.journal.latitude!, widget.journal.longitude!);
        }
        Navigator.of(context)
            .pushNamed(MapScreen.routeName,
                arguments: Tuple2<bool, LatLng?>(true, currentLocation))
            .then((latLng) {
          if (latLng is LatLng) {
            widget.journal.latitude = latLng.latitude;
            widget.journal.longitude = latLng.longitude;
            print(latLng);
            print(widget.journal.latitude);
            print(widget.journal.longitude);
          }
          final journalStore =
              Provider.of<JournalStore>(context, listen: false);
          journalStore.save(widget.journal);
          IOHelper.writeJournalStore(journalStore);
        });
        break;
      default:
        break;
      // TODO handle 'calendar' case
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return [
      DropdownMenuItem(
        child: Row(
          children: [
            Icon(
              Icons.save,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              "Save",
              style: Theme.of(context).textTheme.button,
            )
          ],
        ),
        value: 'save',
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
            const SizedBox(
              width: 8,
            ),
            Text('Add to Calendar', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'calendar',
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            Icon(Icons.edit, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text('Edit Title', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'editTitle',
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            Icon(Icons.map, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text('Set Location', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'setLocation',
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            const Icon(Icons.delete, color: Colors.red),
            const SizedBox(
              width: 8,
            ),
            Text('Delete', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'delete',
      ),
    ];
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: Text(widget.journal.title),
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(12.0),
            icon: Icon(Icons.more_vert_rounded,
                color: Theme.of(context).primaryIconTheme.color),
            onChanged: (newValue) => onDropdownSelect(newValue, context),
            items: dropdownItems,
          ),
        )
      ],
    );
  }

  Widget body(quill.QuillController controller) {
    return Column(
      children: [
        Expanded(
          child: quill.QuillEditor(
            controller: controller,
            padding: const EdgeInsets.all(8.0),
            readOnly: false,
            scrollController: ScrollController(),
            scrollable: true,
            expands: false,
            focusNode: _focusNode,
            autoFocus: true,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 8.0,
                color: Colors.black38,
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: quill.QuillToolbar.basic(
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = quill.QuillController(
      document: widget.journal.document,
      selection: const TextSelection.collapsed(offset: 0),
      keepStyleOnNewLine: false,
    );
    return Scaffold(
      appBar: appBar(context),
      body: WillPopScope(
        onWillPop: () async {
          final journalStore =
              Provider.of<JournalStore>(context, listen: false);
          journalStore.save(widget.journal);
          await IOHelper.writeJournalStore(journalStore);
          Navigator.pop(context);
          return true;
        },
        child: SafeArea(
          child: body(controller),
        ),
      ),
    );
  }
}
