import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_android_flutter/sqlite/provider.dart';
import 'package:ios_android_flutter/widgets/main_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/theme.dart';
import '../sqlite/task_model.dart';
import '../utils/helper.dart';

class EditPage extends StatelessWidget {
  final Task task;
  final List<String> categories;

  EditPage({required this.task, required this.categories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppLocalizations.of(context)?.appName ?? '',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme:
            ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
        home: SafeArea(child: EditWidget(task: task, categories: categories)));
  }
}

class EditWidget extends StatefulWidget {
  final Task task;
  final List<String> categories;

  const EditWidget({Key? key, required this.task, required this.categories})
      : super(key: key);

  @override
  State<EditWidget> createState() => _EditWidget(task, categories);
}

class _EditWidget extends State<EditWidget> {
  final Task task;
  final List<String> categories;

  var nameInputControl = TextEditingController();
  var categoryInputControl = TextEditingController();
  var dateInputControl = TextEditingController();
  var timeInputControl = TextEditingController();
  var contentInputControl = TextEditingController();
  var nameValid = true;

  late DateTime _date;
  late TimeOfDay _time;
  late bool isAdd;

  _EditWidget(this.task, this.categories) {
    _date = Helper.parseDate(task.date);
    _time = Helper.getTimeFromDateTime(_date);
    nameInputControl.text = task.name;
    categoryInputControl.text = task.category;
    dateInputControl.text = Helper.dateToString(_date);
    timeInputControl.text = Helper.timeToString(_time);
    contentInputControl.text = task.content;
    isAdd = task.id == null;
  }

  @override
  void dispose() {
    nameInputControl.dispose();
    categoryInputControl.dispose();
    dateInputControl.dispose();
    timeInputControl.dispose();
    contentInputControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameInputControl.addListener(validateName);
  }

  void validateName() {
    bool validate = nameInputControl.text.isNotEmpty;
    if (validate != nameValid) {
      setState(() {
        nameValid = validate;
      });
    }
  }

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
        dateInputControl.text = Helper.dateToString(_date);
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, childWidget) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if (newTime != null) {
      setState(() {
        _time = newTime;
        timeInputControl.text = Helper.timeToString(_time);
      });
    }
  }

  Future<void> save() async {
    if (nameInputControl.text.isNotEmpty) {
      var name = nameInputControl.text;
      var category = categoryInputControl.text;
      var date = dateInputControl.text;
      var time = timeInputControl.text;
      var content = contentInputControl.text;
      Task newTask = Task(
          id: null,
          name: name,
          category: category,
          date: date + " " + time,
          content: content,
          done: task.done,
          selected: task.selected);
      if (isAdd) {
        await DBProvider.db.newTask(newTask);
        navigateToMain();
      } else {
        newTask.id = task.id;
        await DBProvider.db.updateTask(newTask);
        navigateToMain();
      }
    } else {
      if (nameValid) {
        setState(() {
          nameValid = false;
        });
      }
    }
  }

  void navigateToMain() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? getVerticalEdit()
          : getHorizontalEdit();
    });
  }

  getVerticalEdit() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(isAdd ? AppLocalizations.of(context)?.createTitle ?? '' : AppLocalizations.of(context)?.editTitle ?? '',
                  style: TextStyle(fontSize: 32))),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: nameInputControl,
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          suffixIcon: nameValid
                              ? null
                              : Icon(Icons.error, color: Colors.red),
                          hintText: AppLocalizations.of(context)?.nameHint ?? '',
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
                      controller: categoryInputControl,
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
                              return categories.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(choice)),
                                );
                              }).toList();
                            },
                          ),
                          hintText: AppLocalizations.of(context)?.categoryHint ?? '',
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
                      controller: dateInputControl,
                      readOnly: true,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                              icon: Icon(Icons.date_range,
                                  color: CustomColors.colorHighlight),
                              onPressed: _selectDate),
                          hintText: AppLocalizations.of(context)?.dateHint ?? '',
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
                      controller: timeInputControl,
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
                          hintText: AppLocalizations.of(context)?.timeHint ?? '',
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
                      controller: contentInputControl,
                      maxLines: 10,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppLocalizations.of(context)?.contentHint ?? '',
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
                  onPressed: () {
                    save();
                  },
                  child: Text(AppLocalizations.of(context)?.saveButton ?? ''),
                ))
          ])
        ])));
  }

  getHorizontalEdit() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(isAdd ? AppLocalizations.of(context)?.createTitle ?? '' : AppLocalizations.of(context)?.editTitle ?? '',
                  style: TextStyle(fontSize: 32))),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: nameInputControl,
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(fontSize: 16, height: 0.6),
                          suffixIcon: nameValid
                              ? null
                              : Icon(Icons.error, color: Colors.red),
                          hintText: AppLocalizations.of(context)?.nameHint ?? '',
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
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: categoryInputControl,
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
                            onSelected: (result) {
                              categoryInputControl.text = result.toString();
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context) {
                              return categories.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(choice)),
                                );
                              }).toList();
                            },
                          ),
                          hintText: AppLocalizations.of(context)?.categoryHint ?? '',
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
                      controller: dateInputControl,
                      readOnly: true,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                              icon: Icon(Icons.date_range,
                                  color: CustomColors.colorHighlight),
                              onPressed: _selectDate),
                          hintText: AppLocalizations.of(context)?.dateHint ?? '',
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
                    ))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: timeInputControl,
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
                          hintText: AppLocalizations.of(context)?.timeHint ?? '',
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
                      controller: contentInputControl,
                      maxLines: 3,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: CustomColors.primaryColor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppLocalizations.of(context)?.contentHint ?? '',
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
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 46),
                      primary: CustomColors.secondaryColor,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      )),
                  onPressed: () {
                    save();
                  },
                  child: Text(AppLocalizations.of(context)?.saveButton ?? ''),
                ))
          ])
        ])));
  }
}
