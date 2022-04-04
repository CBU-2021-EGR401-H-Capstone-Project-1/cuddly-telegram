import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

List _months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[700],
      ),
      home: const CalendarPage(title: 'Calendar'),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int count = 0;
  String currentMon = '';
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<JournalStore>(context, listen: false)
        .journals
        .where((element) => element.calendarDate != null)
        .toList();
    count = _now.month;
    currentMon = _months[count - 1];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(currentMon),
            ]),
      ),
    );
  }
}
