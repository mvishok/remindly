import 'package:flutter/material.dart';
import 'package:remindly/main.dart';
import 'package:sqflite/sqflite.dart';

class ViewReminder extends StatefulWidget {
  //get event title and body as parameters
  final int id;

  const ViewReminder({super.key, required this.id});
  //now when calling this widget, pass the event title and body as parameters like this:
  //ViewReminder(title: 'Take LLR', body: 'Take your Learner\'s License with you');
  @override
  State<ViewReminder> createState() => _ViewReminderState();
}

class _ViewReminderState extends State<ViewReminder> {

  final List<Map<String, dynamic>> items = [
    {},
  ];

  String title = '';

  @override
  void initState() {
    super.initState();
    _getReminder();
  }

  Future<void> _getReminder() async {
    final database = await initializeDatabase();
    final List<Map<String, dynamic>> reminders = await fetchReminder(database);

    setState(() {
      items.clear();
      
      //split eventItems into a list separated by commas
      final List<String> eventItems = reminders[0]['eventItems'].split(',');
      
      //add each item to the items list
      for (int i = 0; i < eventItems.length; i++) {
        items.add({
          'title': eventItems[i],
          'isChecked': false,
        });
      }

      title = reminders[0]['eventName'];
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

  Future<List<Map<String, dynamic>>> fetchReminder(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('reminders WHERE id = ${widget.id}');
    return maps;
  }

  bool get allChecked => items.every((item) => item['isChecked'] == true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "It's Time!",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 35,
                color: Color(0xff000000),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                color: Color(0xff000000),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (items[index].isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return CheckboxListTile(
                    title: Text(items[index]['title']),
                    value: items[index]['isChecked'],
                    onChanged: (bool? value) {
                      setState(() {
                        items[index]['isChecked'] = value!;
                      });
                    },
                  );
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: allChecked ? () async {
              final database = await initializeDatabase();
              await database.delete('reminders', where: 'id = ?', whereArgs: [widget.id]);
              if (context.mounted) { 
                ReminderApp.navigatorKey.currentState?.pop(true);
              }
            } : null,
            color: const Color(0xff4bb543),
            iconSize: 48,
          ),
        ],
      ),
    );
  }
}
