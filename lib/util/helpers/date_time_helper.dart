import 'package:flutter/material.dart';

/// A tiny utility class to show Date, Time, and DateTime pickers
/// and return strongly-typed values with sensible defaults.
///
/// Works with Material apps. If you need Cupertino, you can
/// add a platform check and use CupertinoDatePicker similarly.
class DateTimeHelper {
  const DateTimeHelper._();

  static Future<DateTime?> selectDateTime({
    required BuildContext context,

    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    initialDate ??= DateTime(now.year, now.month, now.day);

    // Step 1: Pick Date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return null; // user ne cancel kiya

    // Step 2: Pick Time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      helpText: "Select Time", // optional label
    );

    if (pickedTime == null) return null; // user ne cancel kiya

    // Step 3: Combine Date + Time
    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    return selectedDateTime;
  }
}
