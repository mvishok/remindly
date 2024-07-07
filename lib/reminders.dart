import 'package:flutter/material.dart';
import 'add.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  final List<Map<String, dynamic>> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 30
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return ListTile(
            title: Text(reminder['event']),
            subtitle: Text(reminder['time'].toString()),
            onTap: () {
              // Handle tap to view reminder details
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          navigateToAddReminder();
         },
        child: const Icon(Icons.add),
      ),
    );
  }

  void navigateToAddReminder() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return add();
        },
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
