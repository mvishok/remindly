import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'about.dart';
import 'add.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
  //_ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  final List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final database = await initializeDatabase();
    final List<Map<String, dynamic>> reminders = await fetchReminders(database);

    setState(() {
      _reminders.clear();
      _reminders.addAll(reminders);
    });
  }

  Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/reminders.db';

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY, eventName TEXT, eventItems TEXT, eventDateTime TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> fetchReminders(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return maps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          child: Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          onTap: () async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const About();
                },
                transitionDuration: const Duration(milliseconds: 250),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet. Tap + to add one.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return ListTile(
                  title: Text(reminder['eventName']),
                  subtitle: Text(reminder['eventDateTime'].toString()),
                  onLongPress: () => {
                    //simple dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Reminder'),
                          content: const Text(
                              'Are you sure you want to delete this reminder?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final database = await initializeDatabase();
                                await database.delete(
                                  'reminders',
                                  where: 'id = ?',
                                  whereArgs: [reminder['id']],
                                );

                                //cancel scheduled notification
                                await AwesomeNotifications().cancel(reminder['id']);

                                await _loadReminders();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reminder deleted'),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    ),
                  },
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () {
                setState(() {
                  _loadReminders();
                });
              },
              child: const Icon(Icons.refresh),
            ),
            const Spacer(),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () {
                navigateToAddReminder();
              },
              child: const Icon(Icons.add),
            ),
            
          ],
        ),
      ),
    );
  }

  void navigateToAddReminder() async {
    var refresh = await Navigator.of(context).push(
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
    if (refresh != null && refresh) {
      setState(() {
        _loadReminders();
      });
    }
  }
}
