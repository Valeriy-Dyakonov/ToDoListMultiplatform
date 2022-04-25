import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../sqlite/task_model.dart';
import '../utils/helper.dart';

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
  int _selectedDestination = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isToAdd = true;

  List<Task> tasks = <Task>[
    Task(
        id: 1,
        name: "Task 1",
        category: "Home",
        date: "22/12/2022 22:23",
        content: "Content 1",
        done: "true",
        selected: false),
    Task(
        id: 2,
        name: "Task 2",
        category: "",
        date: "22/11/2022 22:23",
        content: "Content 2",
        done: "false",
        selected: false)
  ];

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
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
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Header',
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Item 1'),
                selected: _selectedDestination == 0,
                onTap: () => selectDestination(0),
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Item 2'),
                selected: _selectedDestination == 1,
                onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('Item 3'),
                selected: _selectedDestination == 2,
                onTap: () => selectDestination(2),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Item A'),
                selected: _selectedDestination == 3,
                onTap: () => selectDestination(3),
              ),
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
            // Respond to item press.
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
            // Respond to button press
          },
          child: Icon(isToAdd ? Icons.add : Icons.delete),
        ));
  }

  InkWell getCard(Task task) {
    return InkWell(
        onTap: () => {},
        onLongPress: () => {
        onCardLongClick(task)
    },
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
      Text(task.date, style: TextStyle(color: CustomColors.inputColor)),
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

  void onCheckBoxClick(Task task) {
    var firstWhere = tasks.firstWhere((element) => element.id == task.id);
    firstWhere.done = Helper.boolToString(!Helper.parseBool(firstWhere.done));
    setState(() {});
  }

  void onCardLongClick(Task task) {
    var firstWhere = tasks.firstWhere((element) => element.id == task.id);
    firstWhere.selected = !firstWhere.selected;
    isToAdd = !tasks.any((element) => element.selected);
    setState(() {});
  }
}
