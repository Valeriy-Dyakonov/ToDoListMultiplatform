import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../sqlite/task_model.dart';

// class EditPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Organizer',
//         theme:
//         ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
//         home: SafeArea(child: EditWidget()));
//   }
// }

class EditWidget extends StatefulWidget {
  final Task task;

  const EditWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<EditWidget> createState() => _EditWidget(task);
}

class _EditWidget extends State<EditWidget> {
  final Task task;

  _EditWidget(this.task);

  DateTime _date = DateTime.now();

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0,10), child: Text(task.id == null ? "Create new task" : "Edit task",
              style: TextStyle(fontSize: 32))),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          // suffixIcon: loginValid == null
                          //     ? null
                          //     : Icon(Icons.error, color: Colors.red),
                          hintText: 'Name',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.colorHighlight, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    )))
          ]),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          suffixIcon: PopupMenuButton(
                            offset: Offset(0, 50),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: CustomColors.colorHighlight),
                            itemBuilder: (BuildContext context) {
                              return ["2", "3"].map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(choice)),
                                );
                              }).toList();
                            },
                          ),
                          hintText: 'Category',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.colorHighlight, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    )))
          ]),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      readOnly: true,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.date_range,
                                  color: CustomColors.colorHighlight),
                              onPressed: _selectDate),
                          hintText: 'DD/MM/YYYY',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.colorHighlight, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    )))
          ]),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      readOnly: true,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.access_time_outlined,
                                  color: CustomColors.colorHighlight),
                              onPressed: _selectTime),
                          hintText: 'HH:mm',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.colorHighlight, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    )))
          ]),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      maxLines: 10,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Content',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.colorHighlight, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    )))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 46),
                      primary: CustomColors.secondaryColor,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  onPressed: () {},
                  child: const Text('Save'),
                ))
          ])
        ])));
  }
}
