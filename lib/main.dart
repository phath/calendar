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
            DateTime(2019, 11, 17),
            selectedDates: List.generate(
                    3, (i) => DateTime(2019, 11, 19).add(Duration(days: 7 * i)))
                .toList(),
            isStartDate: false,
            padding: 0.0,
            border: 0.0,
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
  });
  @required
  final int nRows;
  final DateTime startDate;
  final bool isStartDate;
  final Map<int, String> headerMap;
  final double border;
  final double padding;
  final List<DateTime> selectedDates;

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
        .map(
          (l) => CalendarRow(l
              .map((d) => Date(
                  d,
                  selectedDates.indexWhere((e) => d.isAtSameMomentAs(e)) >= 0
                      ? true
                      : false))
              .toList()),
        )
        .toList();
    int duplicateCount = 0;
    indices.keys.toList().asMap().forEach(
          (i, k) => indices[k].forEach((month, isDuplicate) => {
                if (nRows > 3)
                  {
                    if (isDuplicate)
                      {
                        rows.insert(k + duplicateCount,
                            rows.elementAt(k + duplicateCount)),
                        rows.insert(
                            k + duplicateCount + 1,
                            CalendarRow(
                                listDates
                                    .elementAt(k)
                                    .map((d) => Date(d, false))
                                    .toList(),
                                isDateList: false)),
                        duplicateCount += 2,
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
                                isDateList: false)),
                      }
                  }
              }),
        );
    rows.insert(
      0,
      CalendarHeaderRow(
        listDates.elementAt(0).map((d) => Date(d, false)).toList(),
        backgroundColor: Colors.grey[300],
      ),
    );
    return nRows <= 3 ? rows.getRange(0, nRows + 1).toList() : rows;
  }
}