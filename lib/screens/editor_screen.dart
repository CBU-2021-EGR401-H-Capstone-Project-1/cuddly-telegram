import 'dart:convert';
import 'dart:math';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:cuddly_telegram/widgets/editor_screen/edit_notification_alert_dialog.dart';
import 'package:cuddly_telegram/widgets/editor_screen/edit_title_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cuddly_telegram/widgets/editor_screen/add_calendar_date_dialog.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, required this.journal}) : super(key: key);
  final Journal journal;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final FocusNode _focusNode = FocusNode();
  late quill.QuillController controller;
  late List<DropdownMenuItem<String>> dropdownItems = generateDropdownItems();
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _save() async {
    Provider.of<JournalStore>(context, listen: false).save(widget.journal);
    await IOHelper.writeJournalStore(
        Provider.of<JournalStore>(context, listen: false));
  }

  Future<void> _delete() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.red.shade900.withOpacity(0.75),
      barrierLabel: 'Warning',
      useSafeArea: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Are you sure?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () async {
                Provider.of<JournalStore>(context, listen: false)
                    .remove(widget.journal);
                await IOHelper.writeJournalStore(
                    Provider.of<JournalStore>(context, listen: false));
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            )
          ],
          content: Text(
            'You cannot undo this deletion.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  void _updateTitle() {
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
            _save();
          },
        );
      },
    );
  }

  void _setLocation() {
    final journalStore = Provider.of<JournalStore>(context, listen: false);
    LatLng? currentLocation;
    if (widget.journal.latitude != null && widget.journal.longitude != null) {
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
      } else {
        widget.journal.latitude = null;
        widget.journal.longitude = null;
      }
      journalStore.save(widget.journal);
      IOHelper.writeJournalStore(journalStore);
    });
  }

  Future<void> _updateReminder() async {
    if (widget.journal.notificationId != null) {
      await notificationsPlugin.cancel(widget.journal.notificationId!);
      widget.journal.notificationId = null;
      _save();
    } else {
      final metadata =
          await showDialog<Tuple4<String, String, TimeOfDay, DateTime>>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return EditNotificationAlertDialog(
                journal: widget.journal,
                onSavePressed: (metadata) {
                  return metadata;
                },
              );
            },
          );
        },
      );
      if (metadata != null) {
        final random = Random();
        final notificationId = random.nextInt(100000);
        final title = metadata.item1;
        final body = metadata.item2;
        final time = metadata.item3;
        final date = metadata.item4;
        tz.initializeTimeZones();
        final location =
            tz.getLocation(await FlutterNativeTimezone.getLocalTimezone());
        final tzDateTime = tz.TZDateTime(
            location, date.year, date.month, date.day, time.hour, time.minute);
        final androidDetails = AndroidNotificationDetails(
          'com.egr402.cuddly_telegram',
          'Reminders',
          category: 'CATEGORY_REMINDER',
          color: Theme.of(context).colorScheme.primary,
          subText: widget.journal.title,
        );
        final details = NotificationDetails(android: androidDetails);
        await notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tzDateTime,
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: widget.journal.id,
        );
        print(await notificationsPlugin.pendingNotificationRequests());
        widget.journal.notificationId = notificationId;
        _save();
      } else {
        print("Could not retrieve metadata");
      }
    }
  }

  void onDropdownSelect(String? newValue, BuildContext context) async {
    switch (newValue) {
      case 'save':
        _save();
        break;
      case 'delete':
        _delete();
        break;

      case 'calendar':
        showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) {
            return AddDateDialog(
              journal: widget.journal,
              onSavePressed: (date) {
                widget.journal.calendarDate = date;
                final journalStore =
                    Provider.of<JournalStore>(context, listen: false);
                journalStore.save(widget.journal);
                IOHelper.writeJournalStore(journalStore);
              },
            );
          },
        );
        break;
      case 'editTitle':
        _updateTitle();
        break;
      case 'setLocation':
        _setLocation();
        break;
      case 'notification':
        await _updateReminder();
        break;
      case 'bible':
        if (!await launch('https://www.bible.com/bible/')) {
          throw 'Could not launch Bible website';
        }
        break;
      case 'debug':
        print(jsonEncode(widget.journal.document.toDelta().toJson()));
        break;
      default:
        break;
      // TODO handle 'calendar' case
    }
  }

  List<DropdownMenuItem<String>> generateDropdownItems() {
    return [
      DropdownMenuItem(
        child: Row(
          children: [
            Icon(
              Icons.save,
              color: Theme.of(context).colorScheme.primary,
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
            const SizedBox(width: 8),
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
            Icon(
                widget.journal.notificationId != null
                    ? Icons.notifications
                    : Icons.notifications_none,
                color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
                widget.journal.notificationId != null
                    ? 'Clear Reminder'
                    : 'Set Reminder',
                style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'notification',
      ),
      DropdownMenuItem(
        child: Row(
          children: [
            const Icon(Icons.delete, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'delete',
      ),
      if (controller.document.toPlainText().trim().compareTo("bible") == 0)
        DropdownMenuItem(
          child: Row(
            children: [
              const Icon(Icons.book, color: Colors.brown),
              const SizedBox(width: 8),
              Text('Bible', style: Theme.of(context).textTheme.button),
            ],
          ),
          value: 'bible',
        ),
      // DropdownMenuItem(
      //   child: Row(
      //     children: [
      //       const Icon(Icons.bug_report, color: Colors.green),
      //       const SizedBox(width: 8),
      //       Text('Debug', style: Theme.of(context).textTheme.button),
      //     ],
      //   ),
      //   value: 'debug',
      // ),
    ];
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: Text(widget.journal.title),
      titleSpacing: 0.0,
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(12.0),
            icon: Icon(Icons.more_vert_rounded,
                color: Theme.of(context).primaryIconTheme.color),
            onTap: () => setState(() {
              dropdownItems = generateDropdownItems();
            }),
            onChanged: (newValue) => onDropdownSelect(newValue, context),
            items: dropdownItems,
          ),
        )
      ],
    );
  }

  Widget get body {
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
    controller = quill.QuillController(
      document: widget.journal.document,
      selection: const TextSelection.collapsed(offset: 0),
      keepStyleOnNewLine: false,
    );

    // Clear invalid notifications from journal
    notificationsPlugin.pendingNotificationRequests().then((value) {
      if (!value
          .any((element) => element.id != widget.journal.notificationId)) {
        widget.journal.notificationId = null;
        _save();
      }
    });

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
          child: body,
        ),
      ),
    );
  }
}
