import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class AddDateDialog extends StatelessWidget {
  const AddDateDialog(
      {Key? key, required this.journal, required this.onSavePressed})
      : super(key: key);

  final Journal journal;
  final Function(DateTime) onSavePressed;

  @override
  Widget build(BuildContext context) {
    // DateTime now = new DateTime.now();
    // DateTime date = new DateTime(now.year, now.month, now.day);
    // print(Intl.Intl.systemLocale);

    var format = DateFormat.yMd(Platform.localeName);
    var dateString = format.format(DateTime.now());
    var finalDate = DateTime.now();

    final controller = TextEditingController(text: journal.title);
    return AlertDialog(
      title: Text(
        'Add Date',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      elevation: 6,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Column(
          children: [
            TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1996, 3, 4),
                      maxTime: DateTime(2025, 12, 31), onChanged: (date) {
                    finalDate = date;
                    // print('change $date');
                  }, onConfirm: (date) {
                    // print('confirm $date');
                    finalDate = date;
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  'Select Date',
                  style: TextStyle(color: Colors.blue),
                )),
            Text(dateString),
            Text(""),
            TextButton(
              child:
                  Align(alignment: Alignment.center, child: const Text('Ok')),
              onPressed: () {
                onSavePressed(finalDate);
                Navigator.pop(context, 'Ok');
              },
            ),
            TextButton(
              child: Align(
                  alignment: Alignment.center, child: const Text('Cancel')),
              onPressed: () => Navigator.pop(context, 'Cancel'),
            ),
          ],
        )
      ],
    );
  }
}
