import 'dart:developer';

import 'package:flutter/material.dart';

import '../src/rust/api/init.dart';

Future setupLogger() async {
  setupLogStream().listen((msg) {
    // This should use a logging framework in real applications
    log("${msg.logLevel} ${msg.lbl.padRight(8)}: ${msg.msg}");
  });
}

Future<String> selectDateTime(BuildContext context) async {
  String datetime = "";
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (date != null && date != DateTime.now()) {
    datetime += date.toString().substring(0, 10);
  }
  if (!context.mounted) {
    return datetime;
  }
  final time =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (!context.mounted) {
    return datetime;
  }
  if (time != null && time != TimeOfDay.now()) {
    datetime += " ${time.format(context)}";
  }
  return datetime;
}
