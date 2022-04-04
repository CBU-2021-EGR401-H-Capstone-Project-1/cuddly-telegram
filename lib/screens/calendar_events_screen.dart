import 'dart:io' as IO;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:cuddly_telegram/screens/calendar_screen.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cuddly_telegram/screens/sample_events.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/calendar/v3.dart' as v3;

// class CalendarScreen extends StatelessWidget {
//   const CalendarScreen({Key? key}) : super(key: key);

//   static const routeName = '/calendar';

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Calendar',
//       theme: ThemeData(
//         // is not restarted.
//         primaryColor: Colors.blue[700],
//       ),
//       home: const MyHomePage(title: 'Calendar'),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const routeName = '/calendar';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Map<String, Object>> _pages;

  void onDropdownSelect(String? newValue, BuildContext context) {
    switch (newValue) {
      case 'save':
        print("add to calendar");
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
              "Add to Calendar",
              style: Theme.of(context).textTheme.button,
            )
          ],
        ),
        value: 'Calendar',
      ),
    ];
  }

  @override
  void initState() {
    _pages = [
      {
        'page': CalendarPage(title: "Calendar"),
      },
    ];
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Calendar',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _sampleEvents = calendarEvents(context);
    final cellCalendarPageController = CellCalendarPageController();
    final page = _pages[_selectedIndex]['page'] as Widget;

    return Scaffold(
      appBar: AppBar(title: Text("Calendar"), actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(12.0),
            icon: Icon(Icons.more_vert_rounded,
                color: Theme.of(context).primaryIconTheme.color),
            onChanged: (newValue) => onDropdownSelect(newValue, context),
            items: dropdownItems,
          ),
        )
      ]),
      body: FutureBuilder<List<CalendarEvent>>(
          // initialData: [],
          future: _sampleEvents,
          builder: (context, snapshot) {
            return CellCalendar(
              cellCalendarPageController: cellCalendarPageController,
              events: snapshot.data!,
              daysOfTheWeekBuilder: (dayIndex) {
                final labels = ["S", "M", "T", "W", "T", "F", "S"];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    labels[dayIndex],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              monthYearLabelBuilder: (datetime) {
                final year = datetime!.year.toString();
                final month = datetime.month.monthName;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        "$month  $year",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          cellCalendarPageController.animateToDate(
                            DateTime.now(),
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 300),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
              onCellTapped: (date) {
                final eventsOnTheDate = snapshot.data!.where((event) {
                  final eventDate = event.eventDate;
                  return eventDate.year == date.year &&
                      eventDate.month == date.month &&
                      eventDate.day == date.day;
                }).toList();
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text(
                              date.month.monthName + " " + date.day.toString()),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: eventsOnTheDate
                                .map(
                                  (event) => Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.only(bottom: 12),
                                    color: event.eventBackgroundColor,
                                    child: Text(
                                      event.eventName,
                                      style: TextStyle(
                                          color: event.eventTextColor),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ));
              },
              onPageChanged: (firstDate, lastDate) {
                /// Called when the page was changed
                /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
              },
            );
          }),
    );
  }
}
