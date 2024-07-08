import 'package:flutter/material.dart';

class ViewReminder extends StatefulWidget {
  //get event title and body as parameters
  final String title;
  final String body;

  const ViewReminder({super.key, required this.title, required this.body});
  //now when calling this widget, pass the event title and body as parameters like this:
  //ViewReminder(title: 'Take LLR', body: 'Take your Learner\'s License with you');
  @override
  State<ViewReminder> createState() => _ViewReminderState();
}

class _ViewReminderState extends State<ViewReminder> {
  final List<Map<String, dynamic>> items = [
    {'title': 'Take LLR', 'isChecked': false},
    {'title': 'Take Water Bottle', 'isChecked': false},
    {'title': 'Bring Documents', 'isChecked': false},
  ];

  bool get allChecked => items.every((item) => item['isChecked'] == true);

  @override
  Widget build(BuildContext context) {
    print(widget.title);
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
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "[event]",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
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
                return CheckboxListTile(
                  title: Text(items[index]['title']),
                  value: items[index]['isChecked'],
                  onChanged: (bool? value) {
                    setState(() {
                      items[index]['isChecked'] = value!;
                    });
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: allChecked ? () {} : null,
            color: const Color(0xff4bb543),
            iconSize: 48,
          ),
        ],
      ),
    );
  }
}
