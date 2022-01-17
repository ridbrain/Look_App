import 'package:look_app/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimeCell extends StatefulWidget {
  TimeCell({
    required this.date,
    required this.onSelect,
    required this.selected,
  });

  final int date;
  final bool selected;
  final Function() onSelect;

  @override
  _TimeCellState createState() => _TimeCellState();
}

class _TimeCellState extends State<TimeCell> {
  _getFormated(String format) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      widget.date * 1000,
    );
    Localizations.localeOf(context).languageCode;
    final DateFormat formatter = DateFormat(format, "ru");
    return formatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: Constants.radius,
      color: widget.selected ? Colors.grey[800] : Colors.grey[100],
      child: InkWell(
        borderRadius: Constants.radius,
        onTap: widget.onSelect,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getFormated('HH:mm'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.selected ? Colors.white : Colors.black,
                ),
              ),
              // SizedBox(
              //   height: 2,
              // ),
              // Text(
              //   _getTimesOfDay(),
              //   style: TextStyle(
              //     color: widget.selected ? Colors.white : Colors.black,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
