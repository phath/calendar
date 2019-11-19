import 'package:flutter/material.dart';
import 'package:calendar/constants.dart';
import 'package:calendar/model.dart';

class CalendarRow extends StatelessWidget {
  CalendarRow(
    this.dates, {
    this.backgroundColor = Colors.white,
    this.isDateList = true,
    this.rowHeight = 50.0,
    this.isBeforeMonthRow = false,
    this.isAfterMonthRow = false,
    this.weekendTextColor = Colors.grey,
    this.isGreyOutBerforeToday = false,
    this.selectedCellBoxShape = BoxShape.rectangle,
    this.selectedTextColor = Colors.white,
    this.selectedCenterColor = Colors.blue,
    this.selectedBorderColor = Colors.blue,
  });
  @required
  final List<Date> dates;
  final Color backgroundColor;
  final bool isDateList;
  final double rowHeight;
  final bool isBeforeMonthRow;
  final bool isAfterMonthRow;
  final bool isGreyOutBerforeToday;
  final BoxShape selectedCellBoxShape;
  final Color selectedBorderColor;
  final Color selectedCenterColor;
  final Color selectedTextColor;
  final Color weekendTextColor;

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
    DateTime nw = DateTime.now();
    return isDateList
        ? dates
            .map((d) => Expanded(
                  child: CalendarRowCell(
                    d.date.day.toString(),
                    backgroundColor,
                    isOnRowOfDates: isDateList,
                    isSelected: d.isSelected,
                    isDisable: (isBeforeMonthRow || isAfterMonthRow)
                        ? ((isBeforeMonthRow && d.date.day < 10) ||
                                (isAfterMonthRow && d.date.day > 20)
                            ? true
                            : false)
                        : false,
                    dateTextColor: (d.date.weekday == 7 || d.date.weekday == 6)
                        ? weekendTextColor
                        : (isGreyOutBerforeToday &&
                                d.date.isBefore(
                                    DateTime(nw.year, nw.month, nw.day))
                            ? Colors.grey
                            : defaultTextColor),
                    selectedBoxShape: selectedCellBoxShape,
                    selectedTextColor: selectedTextColor,
                    selectedBorderColor: selectedBorderColor,
                    selectedCenterColor: selectedCenterColor,
                  ),
                ))
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
    this.weekendTextColor = defaultTextColor,
    this.headerMap = koreanHeaderMap,
  }) : super(dates);
  @required
  final List<Date> dates;
  final Color backgroundColor;
  final bool isDateList;
  final double rowHeight;
  final Color weekendTextColor;
  final Map<int, String> headerMap;

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
                  headerMap[d.date.weekday],
                  backgroundColor,
                  isOnRowOfDates: false,
                  dateTextColor: d.date.weekday == 6 || d.date.weekday == 7
                      ? weekendTextColor
                      : defaultTextColor,
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
    this.isDisable = false,
    this.isSelected = false,
    this.isOnRowOfDates = true,
    this.isDisplayedAsSchedule = false,
    this.selectedBoxShape = BoxShape.circle,
    this.selectedRectangleBoxShapeRadius = 5.0,
    this.selectedBorderColor = Colors.blue,
    this.selectedCenterColor = Colors.blue,
    this.selectedTextColor = Colors.white,
    this.dateTextColor = defaultTextColor,
  });

  @required
  final String text;
  @required
  final Color backgroundColor;
  final bool isDisable;
  final bool isSelected;
  final bool isOnRowOfDates;
  final bool isDisplayedAsSchedule;
  final Color dateTextColor;
  final BoxShape selectedBoxShape;
  final double selectedRectangleBoxShapeRadius;
  final Color selectedBorderColor;
  final Color selectedCenterColor;
  final Color selectedTextColor;
  static const double paddingSelectedCircle = 5.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: isDisable
          ? Container(
              color: backgroundColor,
            )
          : Container(
              padding: EdgeInsets.all(paddingSelectedCircle),
              color: backgroundColor,
              child: Container(
                decoration: isOnRowOfDates
                    ? BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: isSelected
                              ? selectedBorderColor
                              : backgroundColor,
                        ),
                        color:
                            isSelected ? selectedCenterColor : backgroundColor,
                        shape: selectedBoxShape ?? selectedBoxShape,
                        borderRadius: selectedBoxShape == BoxShape.rectangle
                            ? BorderRadius.all(Radius.circular(
                                selectedRectangleBoxShapeRadius))
                            : null,
                      )
                    : BoxDecoration(
                        color: backgroundColor,
                      ),
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? selectedTextColor : dateTextColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
