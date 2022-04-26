import 'package:flutter/material.dart';
import 'package:ios_android_flutter/sqlite/provider.dart';

import '../helpers/theme.dart';
import '../sqlite/task_model.dart';
import '../utils/helper.dart';
import 'edit_widget.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Organizer',
        theme:
            ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
        home: SafeArea(child: MainWidget()));
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidget();
}

class _MainWidget extends State<MainWidget> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isToAdd = true;

  List<Task> allTasks = <Task>[];
  List<Task> tasks = <Task>[];

  @override
  void initState() {
    super.initState();

    DBProvider.db.getTasks().then((value) {
      setState(() {
        allTasks = value;
        tasks = getListByType("Next 24 hours", value);
      });
    });
  }

  void selectDestination(String type) {
    setState(() {
      tasks = getListByType(type, allTasks);
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text('Tasks'),
          backgroundColor: CustomColors.secondaryColor,
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Text(
                  'Show by Period',
                  style: TextStyle(color: CustomColors.notActive, fontSize: 24)
                ),
              ),
              ListTile(
                title: Text('Overdue'),
                onTap: () => selectDestination('Overdue'),
              ),
              ListTile(
                title: Text('Next 24 hours'),
                onTap: () => selectDestination('Next 24 hours'),
              ),
              ListTile(
                title: Text('Coming days'),
                onTap: () => selectDestination('Coming days'),
              ),
              ListTile(
                title: Text('Week'),
                onTap: () => selectDestination('Week'),
              ),
              ListTile(
                title: Text('Month'),
                onTap: () => selectDestination('Month'),
              ),
              ListTile(
                title: Text('Future'),
                onTap: () => selectDestination('Future'),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Text(
                  'Show by Category',  style: TextStyle(color: CustomColors.notActive, fontSize: 24)
                ),
              ),
              ...getDynamicallyListTileList()
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return getCard(tasks[index]);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: CustomColors.secondaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: CustomColors.notActive,
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: CustomColors.notActive),
          onTap: (value) {
            setState(() => _currentIndex = value);
          },
          items: [
            BottomNavigationBarItem(
              label: 'Tasks',
              icon: Icon(Icons.notes),
            ),
            BottomNavigationBarItem(
              label: 'Map',
              icon: Icon(Icons.map),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.secondaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            onFloatButtonClick();
          },
          child: Icon(isToAdd ? Icons.add : Icons.delete),
        ));
  }

  InkWell getCard(Task task) {
    return InkWell(
        onTap: () => {onCardClick(task)},
        onLongPress: () => {onCardLongClick(task)},
        splashColor: CustomColors.colorHighlight,
        child: Card(
          color: task.selected ? CustomColors.selectedCard : Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          activeColor: CustomColors.colorHighlight,
                          value: Helper.parseBool(task.done),
                          side: MaterialStateBorderSide.resolveWith((states) =>
                              BorderSide(
                                  width: 2.0,
                                  color: CustomColors.colorHighlight)),
                          onChanged: (bool? value) {
                            onCheckBoxClick(task);
                          },
                        ),
                      ),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(task.name,
                                  style: TextStyle(fontSize: 20)))),
                      task.selected
                          ? Icon(Icons.check_circle_sharp,
                              color: CustomColors.selectedCardIcon)
                          : SizedBox.shrink()
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(3, 3, 0, 0),
                      child: getSubtitle(task)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 10, 0, 0),
                    child: Text(
                      task.content,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: CustomColors.inputColor),
                    ),
                  ),
                ],
              )),
        ));
  }

  Row getSubtitle(Task task) {
    return task.category.isNotEmpty
        ? Row(children: [
            Text(Helper.parseDateForCard(task.date), style: TextStyle(color: CustomColors.inputColor)),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
              child: Icon(Icons.bookmark, color: CustomColors.secondaryColor),
            ),
            Text(task.category,
                style: TextStyle(color: CustomColors.colorHighlight))
          ])
        : Row(children: [
            Text(task.date, style: TextStyle(color: CustomColors.inputColor))
          ]);
  }

  List<ListTile> getDynamicallyListTileList() {
    List<ListTile> categories = <ListTile>[];
    getCategories().forEach((element) {
      categories.add(ListTile(
        title: Text(element),
        onTap: () => selectDestination(element),
      ));
    });
    return categories;
  }

  void onCheckBoxClick(Task task) {
    var firstWhere = tasks.firstWhere((element) => element.id == task.id);
    firstWhere.done = Helper.boolToString(!Helper.parseBool(firstWhere.done));
    DBProvider.db.changeStatus(firstWhere).then((value) => setState(() {}));
  }

  void onCardLongClick(Task task) {
    var firstWhere = tasks.firstWhere((element) => element.id == task.id);
    firstWhere.selected = !firstWhere.selected;
    isToAdd = !tasks.any((element) => element.selected);
    setState(() {});
  }

  void onCardClick(Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => EditPage(
      task: task,
      categories: getCategories(),
    )));
  }

  void onFloatButtonClick() {
    if (isToAdd) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(
              task: Task(
                  id: null,
                  name: "",
                  category: "",
                  date: Helper.fullDateToString(DateTime.now()),
                  content: "",
                  done: "false",
                  selected: false),
              categories: getCategories(),
            )),
      );
    } else {
      var toDelete = tasks.where((element) => element.selected).toList();
      DBProvider.db.deleteAll(toDelete).then((value) => setState(() {
        tasks = tasks.where((element) => !element.selected).toList();
        allTasks = allTasks.where((element) => !element.selected).toList();
        isToAdd = true;
      }));
    }
  }

  List<String> getCategories() {
    return tasks.where((e) => e.category.isNotEmpty).map((e) {
      return Helper.capitalizeString(e.category);
    }).toSet().toList();
  }

  List<Task> getListByType(String type, List<Task> list) {
      switch (type) {
        case "Overdue":
          return list.where((element) => Helper.getDiffFromToday(element.date) < 0 && !Helper.parseBool(element.done)).toList();
        case "Next 24 hours":
          return list.where((element) => Helper.getDiffFromToday(element.date) == 0).toList();
        case "Coming days":
          return list.where((element) => Helper.getDiffFromToday(element.date) == 1).toList();
        case "Week":
          return list.where((element) {
            var diffFromToday = Helper.getDiffFromToday(element.date);
            return diffFromToday > 1 && diffFromToday <=7;
          }).toList();
        case "Month":
          return list.where((element) {
            var diffFromToday = Helper.getDiffFromToday(element.date);
            return diffFromToday > 7 && diffFromToday <= 31;
          }).toList();
        case "Future":
          return list.where((element) {
            var diffFromToday = Helper.getDiffFromToday(element.date);
            return diffFromToday > 31;
          }).toList();
        default:
          return list.where((element) => Helper.capitalizeString(element.category) == type).toList();
      }
  }
}
