import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calendar',
      debugShowCheckedModeBanner: false,
      home: CalenderScreen(),
    );
  }
}

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime currentDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var days = _getMonthDays(currentDay);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Row(
        children: List.generate(days.length, (index) {
          var weekday = days[index];
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    weekday.day.substring(0, 1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(weekday.days.length, (index) {
                  var day = weekday.days[index];
                  return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                    height: 100,
                    child: Center(
                      child: Text(
                        '${day.dateTime.day}',
                        style: TextStyle(color: day.isGreyed ? Colors.grey : Colors.black),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<WeekDay> _getMonthDays(DateTime date) {
    var month = date.month;
    var newMonth = month;
    var day = 1;

    List<DateTime> dates = [];

    while (newMonth == month) {
      var newDate = DateTime(date.year, date.month, day);

      newMonth = newDate.month;
      if (newMonth == month) {
        dates.add(newDate);
      }

      day++;
    }

    var groups = groupBy(dates, (e) {
      DateTime date = e as DateTime;
      return date.weekday;
    });

    List<WeekDay> weekdays = [];

    groups.forEach((key, value) {
      var weekDay = WeekDay(
        days: value.map((e) => DateData(dateTime: e, isGreyed: false)).toList(),
        weekday: key,
        day: _getDayName(key),
      );
      weekdays.add(weekDay);
    });

    weekdays.sort((a, b) => a.weekday.compareTo(b.weekday));

    weekdays.insert(0, weekdays.last);
    weekdays.removeLast();

    bool isFirstDay = false;

    for (var weekday in weekdays) {
      var day = weekday.days.first;
      if (day.dateTime.day == 1) {
        isFirstDay = true;
      }

      if (!isFirstDay) {
        weekday.days.insert(
          0,
          DateData(
            dateTime: day.dateTime.subtract(const Duration(days: 7)),
            isGreyed: true,
          ),
        );
      }
    }

    bool isLastDay = false;
    int daysSize = 0;

    for (var weekday in weekdays) {
      var day = weekday.days.last;
      if (day.dateTime.day == dates.length) {
        daysSize = weekday.days.length;
        isLastDay = true;
      }

      if (isLastDay && weekday.days.length < daysSize) {
        weekday.days.add(DateData(
          dateTime: day.dateTime.add(const Duration(days: 7)),
          isGreyed: true,
        ));
      }
    }

    return weekdays;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      default:
        return "Sunday";
    }
  }
}

class WeekDay {
  final int weekday;
  final String day;
  final List<DateData> days;

  WeekDay({
    required this.days,
    required this.weekday,
    required this.day,
  });
}

class DateData {
  final bool isGreyed;
  final DateTime dateTime;

  DateData({required this.dateTime, required this.isGreyed});
}
