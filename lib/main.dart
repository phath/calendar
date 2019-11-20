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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("calendar")),
        body: SingleChildScrollView(
          child: Calendar(
            5,
            DateTime(2019, 11, 19),
            selectedDates: List.generate(
                    3, (i) => DateTime(2019, 11, 19).add(Duration(days: 7 * i)))
                .toList(),
            isStartDate: false,
            padding: 5.0,
            border: 0.0,
            weekendTextColor: Colors.red[200],
            isGreyOutBerforeToday: true,
            selectedCellBoxShape: BoxShape.circle,
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
    this.weekendTextColor = Colors.grey,
    this.isGreyOutBerforeToday = false,
    this.selectedCellBoxShape = BoxShape.circle,
    this.calendarRowHeight = 50.0,
    this.calendarHeaderRowHeight = 50.0,
  });
  @required
  final int nRows;
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

  List<List<DateTime>> _getAllDates() {
    DateTime _lastSunday =
        !isStartDate ? _lookForLastMonday(startDate) : startDate;
    List<DateTime> dates = List.generate(7 * nRows, (int index) => index)
        .map(
          (ele) => _lastSunday.add(
            Duration(days: ele),
          ),
        )
        .toList();
    List<List<DateTime>> listDates = List.generate(nRows, (int index) => index)
        .map((ele) => dates.getRange(ele * 7, (ele + 1) * 7).toList())
        .toList();
    return listDates;
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

  List<Widget> _convertAllDates2CalendarRowWidget() {
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
                  indices.keys.toList().indexWhere((idx) => idx == i) >= 0
                      ? true
                      : false,
              weekendTextColor: weekendTextColor,
              isGreyOutBerforeToday: isGreyOutBerforeToday,
              selectedCellBoxShape: selectedCellBoxShape,
            ),
          ),
        )
        .values
        .toList();
    int duplicateCount = 0;
    indices.keys.toList().asMap().forEach(
          (i, k) => indices[k].forEach((month, isDuplicate) => {
                if (nRows > 3)
                  {
                    if (isDuplicate)
                      {
                        duplicateCount += 1,
                        rows.insert(
                          k + duplicateCount,
                          CalendarRow(
                              listDates
                                  .elementAt(k)
                                  .map((d) => Date(d, false))
                                  .toList(),
                              isDateList: true,
                              isAfterMonthRow: true,
                              isGreyOutBerforeToday: isGreyOutBerforeToday,
                              selectedCellBoxShape: selectedCellBoxShape,
                              weekendTextColor: weekendTextColor),
                        ),
                        rows.insert(
                          k + duplicateCount,
                          CalendarRow(
                              listDates
                                  .elementAt(k)
                                  .map((d) => Date(d, false))
                                  .toList(),
                              isGreyOutBerforeToday: isGreyOutBerforeToday,
                              selectedCellBoxShape: selectedCellBoxShape,
                              isDateList: false,
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
                              weekendTextColor: weekendTextColor,
                              isGreyOutBerforeToday: isGreyOutBerforeToday,
                              selectedCellBoxShape: selectedCellBoxShape,
                              isAfterMonthRow: false),
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
      ),
    );
    return nRows <= 3 ? rows.getRange(0, nRows + 1).toList() : rows;
  }
}
