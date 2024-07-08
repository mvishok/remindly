import 'package:flutter/material.dart';
import 'package:remindly/services/notification_service.dart';
import 'reminders.dart';

void main() async {
  await NotificationService.initializeNotification();
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remindly',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
      ),
      home: const ReminderListScreen(),
    );
  }
}
