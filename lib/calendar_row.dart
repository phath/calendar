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
    this.selectedCellBoxShape = BoxShape.circle,
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
  List<Date> selectedDates;

  @override
  Widget build(BuildContext context) {
    selectedDates = List.from(dates.where((e) => e.isSelected));
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
            .map(
              (d) => Expanded(
                child: CalendarRowCell(
                  d.date.day.toString(),
                  backgroundColor,
                  isOnRowOfDates: isDateList,
                  isSelected: d.isSelected &&
                      (d.date.isAtSameMomentAs(
                              DateTime(nw.year, nw.month, nw.day)) ||
                          d.date.isAfter(DateTime(nw.year, nw.month, nw.day))),
                  isDisable: (isBeforeMonthRow || isAfterMonthRow)
                      ? ((isBeforeMonthRow && d.date.day < 10) ||
                              (isAfterMonthRow && d.date.day > 20)
                          ? true
                          : false)
                      : false,
                  dateTextColor: (d.date.weekday == 6 || d.date.weekday == 7) &&
                          (weekendTextColor != defaultTextColor)
                      ? weekendTextColor
                      : (isGreyOutBerforeToday &&
                              d.date
                                  .isBefore(DateTime(nw.year, nw.month, nw.day))
                          ? Colors.grey
                          : defaultTextColor),
                  isSelectable:
                      d.date.isBefore(DateTime(nw.year, nw.month, nw.day))
                          ? false
                          : true,
                  selectedBoxShape: selectedCellBoxShape,
                  selectedTextColor: selectedTextColor,
                  selectedBorderColor: selectedBorderColor,
                  selectedCenterColor: selectedCenterColor,
                  date: d.date,
                  onDateSelectedCallback: (DateTime dateFromCell) {
                    selectedDates.forEach((e) => print(e.date));
                  },
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
                isSelectable: false,
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
                  isSelectable: false,
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

class CalendarRowCell extends StatefulWidget {
  CalendarRowCell(
    this.text,
    this.backgroundColor, {
    Key key,
    this.date,
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
    this.isSelectable = true,
    this.onDateSelectedCallback,
  }) : super(key: key);

  @required
  final String text;
  @required
  final Color backgroundColor;
  final DateTime date;
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
  final bool isSelectable;
  final Function(DateTime) onDateSelectedCallback;
  //final VoidCallback onDateSelectedCallback;
  //final onDateSelectedCallback;

  _CalendarRowCell createState() => _CalendarRowCell();
}

class _CalendarRowCell extends State<CalendarRowCell> {
  static const double paddingSelectedCircle = 5.0;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(
          () {
            _isSelected =
                widget.isSelectable ? !_isSelected : widget.isSelectable;
            widget.onDateSelectedCallback(widget.date ?? widget.date);
          },
        );
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: widget.isDisable
            ? Container(
                color: widget.backgroundColor,
              )
            : Container(
                padding: EdgeInsets.all(paddingSelectedCircle),
                color: widget.backgroundColor,
                child: Container(
                  decoration: widget.isOnRowOfDates
                      ? BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: _isSelected
                                ? widget.selectedBorderColor
                                : widget.backgroundColor,
                          ),
                          color: _isSelected
                              ? widget.selectedCenterColor
                              : widget.backgroundColor,
                          shape: widget.selectedBoxShape ??
                              widget.selectedBoxShape,
                          borderRadius:
                              widget.selectedBoxShape == BoxShape.rectangle
                                  ? BorderRadius.all(Radius.circular(
                                      widget.selectedRectangleBoxShapeRadius))
                                  : null,
                        )
                      : BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                  alignment: Alignment.center,
                  child: Container(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: _isSelected
                            ? widget.selectedTextColor
                            : widget.dateTextColor,
                        fontWeight:
                            _isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
