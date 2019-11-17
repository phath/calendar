import 'package:flutter/material.dart';
import 'package:calendar/constants.dart';

class CalendarRow extends StatelessWidget {
  CalendarRow(
    this.dates, {
    this.backgroundColor = Colors.white,
    this.isDateList = true,
    this.rowHeight = 50.0,
  });
  @required
  final List<DateTime> dates;
  final Color backgroundColor;
  final bool isDateList;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rowHeight,
      width: double.infinity,
      child: Row(
        children: _getCalendarRow(),
      ),
    );
  }

  List<Widget> _getCalendarRow() {
    return isDateList
        ? dates
            .map(
              (d) => Expanded(
                child: CalendarRowCell(
                  d.day.toString(),
                  backgroundColor,
                ),
              ),
            )
            .toList()
        : <Widget>[
            Expanded(
              child: CalendarRowCell(
                (dates.last.day ==
                        DateTime(dates.last.year,
                                dates.last.add(Duration(days: 28)).month, 0)
                            .day)
                    ? dates.last.add(Duration(days: 28)).month.toString() + "월"
                    : dates.last.month.toString() + "월",
                backgroundColor,
              ),
            )
          ];
  }
}

class CalendarRowCell extends StatelessWidget {
  CalendarRowCell(
    this.text,
    this.backgroundColor,
  );

  @required
  final String text;
  @required
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

class CalendarHeaderRow extends CalendarRow {
  CalendarHeaderRow(
    this.dates, {
    this.backgroundColor = Colors.grey,
    this.isDateList = false,
    this.rowHeight = 50.0,
  }) : super(dates);
  @required
  final List<DateTime> dates;
  final Color backgroundColor;
  final bool isDateList;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rowHeight,
      width: double.infinity,
      child: Row(
        children: dates
            .map(
              (d) => Expanded(
                child: CalendarRowCell(
                  koreanHeaderMap[d.weekday],
                  backgroundColor,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
