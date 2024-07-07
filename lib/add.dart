// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class add extends StatelessWidget {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventItemsController = TextEditingController();
  DateTime? _selectedDateTime;

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

  Future<void> insertReminder(Database db, String eventName, String eventItems,
      DateTime eventDateTime) async {
    await db.insert(
      'reminders',
      {
        'eventName': eventName,
        'eventItems': eventItems,
        'eventDateTime': eventDateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Image.asset('assets/images/logo.png', height: 30),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                "Add a reminder",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 30,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            color: Color(0xffa9a9a9),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                hintText: 'Event name',
                hintStyle: TextStyle(
                  color: Color(0xffa9a9a9),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffa9a9a9),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffa9a9a9),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: TextField(
              controller: _eventItemsController,
              decoration: const InputDecoration(
                hintText: 'Event items (comma separated)',
                hintStyle: TextStyle(
                  color: Color(0xffa9a9a9),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffa9a9a9),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffa9a9a9),
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: ElevatedButton(
                child: const Text('Select date and time'),
                onPressed: () => {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  ).then((date) {
                    if (date != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((time) {
                        if (time != null) {
                          _selectedDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        }
                      });
                    }
                  })
                },
              )),
          //submmit button green
          //cancel button red
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedDateTime != null &&
                        _eventNameController.text.isNotEmpty &&
                        _eventItemsController.text.isNotEmpty) {
                      final database = await initializeDatabase();
                      await insertReminder(database, _eventNameController.text,
                          _eventItemsController.text, _selectedDateTime!);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reminder added successfully')),
                        );

                        Navigator.pop(context, true);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields and select a date/time')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(100, 50),
                  ),
                  child: const Text('Submit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ElevatedButton(
                  onPressed: () {
                    //clear all fields and navigate back
                    _eventNameController.clear();
                    _eventItemsController.clear();
                    _selectedDateTime = null;
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(100, 50),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
