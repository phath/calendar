import 'dart:core';
import 'package:flutter/material.dart';
import 'package:calendar/calendar_row.dart';
import 'package:calendar/constants.dart';
import 'package:calendar/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("subscription")),
        body: SingleChildScrollView(
          child: Calendar(
            20,
            DateTime(2020, 07, 01),
            selectedDates: List.generate(10,
                    (i) => DateTime(2020, 07, 06).add(Duration(days: 2 * i)))
                .toList(),
            isStartDate: false,
            padding: 5.0,
            border: 0.0,
            isGreyOutBerforeToday: true,
            selectedCellBoxShape: BoxShape.circle,
            selectedCenterColor: Colors.blue[200],
            calendarHeaderRowHeight: 30.0,
            onCalendarDateSelected:
                (List<DateTime> selectedDates, DateTime touchedDate) {
              //(DateTime touchedDate) {
              print(selectedDates);
              print(touchedDate);
            },
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  Calendar(
    int this.nRows,
    this.startDate, {
    this.selectedDates = const [],
    this.border = 2.0,
    this.padding = 0.0,
    this.isStartDate = false,
    this.headerMap = koreanHeaderMap,
    this.weekendTextColor = defaultTextColor,
    this.isGreyOutBerforeToday = false,
    this.selectedCellBoxShape = BoxShape.circle,
    this.calendarRowHeight = 50.0,
    this.calendarHeaderRowHeight = 50.0,
    this.selectedCenterColor = Colors.blue,
    this.selectedBorderColor = Colors.blue,
    this.onCalendarDateSelected,
  });
  @required
  final int nRows;
  @required
  final DateTime startDate;
  final bool isStartDate;
  final bool isGreyOutBerforeToday;
  final Map<int, String> headerMap;
  final double border;
  final double padding;
  final List<DateTime> selectedDates;
  final Color weekendTextColor;
  final BoxShape selectedCellBoxShape;
  final double calendarRowHeight;
  final double calendarHeaderRowHeight;
  final Color selectedCenterColor;
  final Color selectedBorderColor;
  @required
  final Function(List<DateTime>, DateTime) onCalendarDateSelected;
  static int minRowToShowMonth = 3;

  List<List<DateTime>> _getAllDates() {
    DateTime _lastSunday =
        !isStartDate ? _lookForLastMonday(startDate) : startDate;
    List<DateTime> _dates = List.generate(7 * nRows, (int index) => index)
        .map(
          (ele) => _lastSunday.add(
            Duration(days: ele),
          ),
        )
        .toList();
    return List.generate(nRows, (int index) => index)
        .map((ele) => _dates.getRange(ele * 7, (ele + 1) * 7).toList())
        .toList();
  }

  DateTime _lookForLastMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: border,
            color: Colors.black45,
          ),
        ),
        child: Column(children: _convertAllDates2CalendarRowWidget()),
      ),
    );
  }

  Map<int, Map<int, bool>> _getIndicesForMonthRow(
      List<List<DateTime>> listDates) {
    Map<int, Map<int, bool>> indices = {};
    listDates.asMap().forEach((i, l) {
      if (l.first.month != l.last.month) {
        indices.addAll({
          i: {l.last.month: true}
        });
      }
      if (l.last.day ==
          DateTime(l.last.year, l.last.add(Duration(days: 28)).month, 0).day) {
        indices.addAll({
          i: {l.last.add(Duration(days: 1)).month: false}
        });
      }
    });
    return indices;
  }

  void _addOrRemoveSelectedDates(DateTime dateFromRow, int addOrRemove) {
    addOrRemove < 0
        ? selectedDates.add(dateFromRow)
        : selectedDates.removeWhere(
            (e) => e.isAtSameMomentAs(dateFromRow),
          );
    onCalendarDateSelected(selectedDates, dateFromRow);
  }

  List<Widget> _convertAllDates2CalendarRowWidget() {
    DateTime nw = DateTime.now();
    List<List<DateTime>> listDates = _getAllDates();
    Map<int, Map<int, bool>> indices = _getIndicesForMonthRow(listDates);
    List<Widget> rows = listDates
        .asMap()
        .map(
          (i, l) => MapEntry(
            i,
            CalendarRow(
              l
                  .map((d) => Date(
                      d,
                      selectedDates.indexWhere((e) => d.isAtSameMomentAs(e)) >=
                              0
                          ? true
                          : false))
                  .toList(),
              isBeforeMonthRow:
                  indices.containsKey(i) && nRows > minRowToShowMonth
                      ? true
                      : false,
              weekendTextColor: weekendTextColor,
              isGreyOutBerforeToday: isGreyOutBerforeToday,
              selectedCellBoxShape: selectedCellBoxShape,
              selectedCenterColor: selectedCenterColor,
              selectedBorderColor: selectedBorderColor,
              onDateSelectedCallbackRow:
                  (DateTime dateFromRow, int addOrRemove) {
                _addOrRemoveSelectedDates(dateFromRow, addOrRemove);
              },
            ),
          ),
        )
        .values
        .toList();
    int duplicateCount = 0;
    indices.keys.toList().asMap().forEach(
          (i, k) => indices[k].forEach((month, isDuplicate) => {
                if (nRows > minRowToShowMonth)
                  {
                    if (isDuplicate)
                      {
                        duplicateCount += 1,
                        rows.insert(
                          k + duplicateCount,
                          CalendarRow(
                            listDates
                                .elementAt(k)
                                .map((d) => Date(
                                    d,
                                    selectedDates.indexWhere(
                                                (e) => d.isAtSameMomentAs(e)) >=
                                            0
                                        ? true
                                        : false))
                                .toList(),
                            isDateList: true,
                            isAfterMonthRow: true,
                            isGreyOutBerforeToday: isGreyOutBerforeToday,
                            selectedCellBoxShape: selectedCellBoxShape,
                            selectedCenterColor: selectedCenterColor,
                            selectedBorderColor: selectedBorderColor,
                            weekendTextColor: weekendTextColor,
                            onDateSelectedCallbackRow:
                                (DateTime dateFromRow, int addOrRemove) {
                              _addOrRemoveSelectedDates(
                                  dateFromRow, addOrRemove);
                            },
                          ),
                        ),
                        rows.insert(
                          k + duplicateCount,
                          CalendarRow(
                              listDates
                                  .elementAt(k)
                                  .map((d) => Date(d, false))
                                  .toList(),
                              isDateList: false,
                              isGreyOutBerforeToday: isGreyOutBerforeToday,
                              selectedCellBoxShape: selectedCellBoxShape,
                              selectedCenterColor: selectedCenterColor,
                              selectedBorderColor: selectedBorderColor,
                              weekendTextColor: weekendTextColor),
                        ),
                        duplicateCount += 1,
                      }
                    else
                      {
                        duplicateCount += 1,
                        rows.insert(
                          k + duplicateCount,
                          CalendarRow(
                            listDates
                                .elementAt(k)
                                .map((d) => Date(d, false))
                                .toList(),
                            isDateList: false,
                            isAfterMonthRow: false,
                            weekendTextColor: weekendTextColor,
                            isGreyOutBerforeToday: isGreyOutBerforeToday,
                            selectedCenterColor: selectedCenterColor,
                            selectedBorderColor: selectedBorderColor,
                            selectedCellBoxShape: selectedCellBoxShape,
                          ),
                        ),
                      }
                  }
              }),
        );
    rows.insert(
      0,
      CalendarHeaderRow(
        listDates.elementAt(0).map((d) => Date(d, false)).toList(),
        backgroundColor: Colors.grey[300],
        weekendTextColor: weekendTextColor,
        rowHeight: calendarHeaderRowHeight,
        isDateList: false,
      ),
    );
    return nRows <= minRowToShowMonth
        ? rows.getRange(0, nRows + 1).toList()
        : rows;
  }
}
