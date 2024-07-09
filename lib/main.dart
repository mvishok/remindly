import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'reminders.dart';
import 'view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReceivedAction?>(
      future: AwesomeNotifications().getInitialNotificationAction(
        removeFromActionEvents: false,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final receivedAction = snapshot.data!;
          final payload = receivedAction.payload ?? {};
          if (payload.containsKey('id')) {
            ReminderApp.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => ViewReminder(id: int.parse(payload['id']!)),
              ),
            );
          }
        }
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Remindly',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.lightBlue,
          ),
          home: const ReminderListScreen(),
        );
      },
    );
  }
}