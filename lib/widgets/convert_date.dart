import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ConvertDate {
  ConvertDate(
    this.context,
  ) {
    initializeDateFormatting();
  }

  final BuildContext context;

  static DateTime dayBegin() {
    var date = DateTime.now();
    return date.add(Duration(hours: -date.hour, minutes: -date.minute));
  }

  String fromUnix(int unix, String format) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      unix * 1000,
    );
    Localizations.localeOf(context).languageCode;
    final DateFormat formatter = DateFormat(format, "ru");
    return formatter.format(date);
  }

  String fromDate(DateTime date, String format) {
    Localizations.localeOf(context).languageCode;
    final DateFormat formatter = DateFormat(format, "ru");
    return formatter.format(date);
  }
}
