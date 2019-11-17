import 'package:flutter/material.dart';
import 'package:calendar/constants.dart';
import 'package:calendar/model.dart';

class CalendarRow extends StatelessWidget {
  CalendarRow(
    this.dates, {
    this.backgroundColor = Colors.white,
    this.isDateList = true,
    this.rowHeight = 50.0,
  });
  @required
  final List<Date> dates;
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
                  d.date.day.toString(),
                  backgroundColor,
                  isOnRowOfDates: isDateList,
                  isSelected: d.isSelected,
                ),
              ),
            )
            .toList()
        : <Widget>[
            Expanded(
              child: CalendarRowCell(
                (dates.last.date.day ==
                        DateTime(
                                dates.last.date.year,
                                dates.last.date.add(Duration(days: 28)).month,
                                0)
                            .day)
                    ? dates.last.date.add(Duration(days: 28)).month.toString() +
                        "월"
                    : dates.last.date.month.toString() + "월",
                backgroundColor,
                isOnRowOfDates: isDateList,
              ),
            )
          ];
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
  final List<Date> dates;
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
                  koreanHeaderMap[d.date.weekday],
                  backgroundColor,
                  isOnRowOfDates: false,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CalendarRowCell extends StatelessWidget {
  CalendarRowCell(
    this.text,
    this.backgroundColor, {
    this.isSelected = false,
    this.isOnRowOfDates = true,
    this.isDisplayedAsSchedule = true,
  });

  @required
  final String text;
  @required
  final Color backgroundColor;
  final bool isSelected;
  final bool isOnRowOfDates;
  final bool isDisplayedAsSchedule;
  static const double paddingSelectedCircle = 5.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(paddingSelectedCircle),
        color: backgroundColor,
        child: Container(
          decoration: isOnRowOfDates
              ? BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: isSelected ? Colors.blue : backgroundColor,
                  ),
                  color: isSelected
                      ? (isDisplayedAsSchedule ? Colors.blue : Colors.blue[50])
                      : backgroundColor,
                  shape: BoxShape.circle,
                )
              : BoxDecoration(
                  color: backgroundColor,
                ),
          alignment: Alignment.center,
          child: Container(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? (isDisplayedAsSchedule ? Colors.white : Colors.blue[300])
                    : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
