import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

///Extensions

extension DateFormated on DateTime {
  DateTime oneMonthBeforeInSameYear() {
    var onemonthbefore = this.subtract(Duration(days: 31));
    if (onemonthbefore.isBefore(DateTime(this.year, 1, 1))) {
      return DateTime(this.year, 1, 1);
    }
    return onemonthbefore;
  }

  DateTime oneMonthBefore() {
    return this.subtract(Duration(days: 31));
  }

  DateTime addDays(int days) {
    return this.add(Duration(days: days));
  }

  DateTime thisMonthAtInit() {
    return DateTime(this.year, this.month, 1);
  }

  DateTime thisMonthAtEnd() {
    return DateTime(this.year, this.month + 1, 0);
  }

  String get toFormatedDate {
    return DateFormat(
      "MMM d, h:mm a",
      Intl.getCurrentLocale(),
    ).format(this);
  }

  String get toShortFormatedDate {
    return DateFormat(
      "EEE, MMM d y",
      Intl.getCurrentLocale(),
    ).format(this);
  }

  String get toPipeFormatedDate {
    return DateFormat(
      'M/d/y',
      Intl.getCurrentLocale(),
    ).format(this);
  }

  String get toPipeFormatedDateWithHours {
    return DateFormat(
      'M/d/y',
      Intl.getCurrentLocale(),
    ).add_jm().format(this);
  }

  String get toFormatedMontYear {
    return DateFormat(
      "yMMMM",
      Intl.getCurrentLocale(),
    ).format(this);
  }

  String get toFormatedDayMontYear {
    return DateFormat(
      "MMM d,y",
      Intl.getCurrentLocale(),
    ).format(this);
  }
}

//Para limitar la cantidad de digitos que envia el ISO8601 y sea parseable por DateTime
String restrictFractionalSeconds(String dateTime) =>
    dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);

DateTime getDateFromStr(String str) {
  return DateTime.parse(restrictFractionalSeconds(str));
}

String formatedDate(DateTime datetime, bool short) {
  String locale = Intl.getCurrentLocale();
  if (short) {
    return DateFormat("EEE, MMM d y", locale).format(datetime);
  } else
    return DateFormat("MMM d, h:mm a", locale).format(datetime);
}

String formatedDateFromStr(String str, {bool short = false}) {
  return formatedDate(getDateFromStr(str), short);
}

Future<DateTime> selectDate(BuildContext context) async {
  final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null) return picked;
  return null;
}

Future<DateTimeRange> selectDateRange(
  BuildContext context, {
  useFlutterOfficial = false,
}) async {
  if (useFlutterOfficial) {
    //Flutter Now Support Officialy DateRange Picker
    final DateTimeRange picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) return picked;
    return null;
  } else {
    //@deprecated
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: oneWeekBefore(),
        initialLastDate: new DateTime.now(),
        firstDate: new DateTime(2015),
        lastDate: (DateTime.now()).add(Duration(days: 1)));
    if (picked != null) {
      if (picked.length == 1) {
        //Si viene un solo elemto el rango es ese propio dia duplico
        picked.add(picked.first);
      }
      return DateTimeRange(start: picked[0], end: picked[1]);
    }
    return null;
  }
}

oneMonthBefore() {
  var now = DateTime.now();
  var onemonthbefore = now.subtract(Duration(days: 31));
  if (onemonthbefore.isBefore(DateTime(DateTime.now().year, 1, 1))) {
    return DateTime(DateTime.now().year, 1, 1);
  }
  return onemonthbefore;
}

oneWeekBefore() {
  var now = DateTime.now();
  var oneWeekBefore = now.subtract(Duration(days: 7));
  if (oneWeekBefore.isBefore(DateTime(DateTime.now().year, 1, 1))) {
    return DateTime(DateTime.now().year, 1, 1);
  }
  return oneWeekBefore;
}
