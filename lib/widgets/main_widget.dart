import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ios_android_flutter/main.dart';
import 'package:ios_android_flutter/sqlite/provider.dart';
import 'package:location/location.dart' as g;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/theme.dart';
import '../sqlite/task_model.dart';
import '../utils/helper.dart';
import 'edit_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  Locale? locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppLocalizations.of(context)?.appName ?? '',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (locale == null) {
              locale = deviceLocale!;
            }
            return locale;
          },
          theme:
              ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
          home: MainWidget(needToWrap: false));
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    return Locale(
        prefs.getString('languageCode')!, prefs.getString('countryCode'));
  }
}

class MainWidget extends StatefulWidget {
  bool needToWrap = true;

  MainWidget({Key? key, required this.needToWrap}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidget(needToWrap);
}

class _MainWidget extends State<MainWidget> {
  bool needToWrap = true;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _MainWidget(this.needToWrap);

  bool isToAdd = true;
  bool trackSteps = false;

  List<Task> allTasks = <Task>[];
  List<Task> tasks = <Task>[];
  List<LatLng> points = <LatLng>[];

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController googleMapController;
  late Position currentPosition;
  late g.Location location;

  void locatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }

    location = g.Location();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition initialPosition =
      CameraPosition(target: LatLng(53.185584, 50.087581), zoom: 14);

  @override
  void initState() {
    super.initState();

    DBProvider.db.getTasks().then((value) {
      setState(() {
        allTasks = value;
        tasks = getListByType("2", value);
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
    return SafeArea(
        child: needToWrap
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppLocalizations.of(context)?.appName ?? '',
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(
                    fontFamily: 'sans-serif-light', errorColor: Colors.red),
                home: getMainContent())
            : getMainContent());
  }

  Scaffold getMainContent() {
    return _currentIndex == 0
        ? getTasksFragment()
        : (_currentIndex == 1 ? getMapFragment() : getSettingsFragment());
  }

  Scaffold getTasksFragment() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(AppLocalizations.of(context)?.notes ?? ''),
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
                    AppLocalizations.of(context)?.drawerMenuTitleTime ?? '',
                    style:
                        TextStyle(color: CustomColors.notActive, fontSize: 24)),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.overdue ?? ''),
                onTap: () => selectDestination("1"),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.today ?? ''),
                onTap: () => selectDestination("2"),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.tomorrow ?? ''),
                onTap: () => selectDestination("3"),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.week ?? ''),
                onTap: () => selectDestination("4"),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.month ?? ''),
                onTap: () => selectDestination("5"),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)?.future ?? ''),
                onTap: () => selectDestination("6"),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Text(
                    AppLocalizations.of(context)?.drawerMenuTitleCategory ?? '',
                    style:
                        TextStyle(color: CustomColors.notActive, fontSize: 24)),
              ),
              ...getDynamicallyListTileList()
            ],
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getCard(tasks[index]);
                  },
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.height * 0.007)),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return getCard(tasks[index]);
                  },
                );
        }),
        bottomNavigationBar: getMenu(),
        floatingActionButton: FloatingActionButton(
          key: Key("addTask"),
          backgroundColor: CustomColors.secondaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            onFloatButtonClick();
          },
          child: Icon(isToAdd ? Icons.add : Icons.delete),
        ));
  }

  Scaffold getMapFragment() {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            polylines: {
              Polyline(
                polylineId: const PolylineId('overview_polyline'),
                color: Colors.red,
                width: 5,
                points: points,
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              googleMapController = controller;
              locatePosition();
            },
            onLongPress: addPoint,
          ),
          Padding(padding: EdgeInsets.all(16),child: FloatingActionButton(
            onPressed: () {
              setState(() {
                trackSteps = !trackSteps;
                if (trackSteps) {
                  trackingSteps();
                }
              });
            },
            backgroundColor: trackSteps ? Colors.red : Colors.green,
            child: const Icon(Icons.navigation),
          )),
        ],
      ),
      floatingActionButton: addClearButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: getMenu(),
    );
  }

  trackingSteps() {
    points.clear();
    location.onLocationChanged.timeout(Duration(milliseconds: 1000)).takeWhile((element) => trackSteps).listen((locationData) async {
      var latLng = LatLng(locationData.latitude!, locationData.longitude!);
      if (points.isEmpty || points.last != latLng) {
        points.add(latLng);
        setState(() {});
      }
    });
  }

  clearPoints() {
    points.clear();
    setState(() {});
  }

  addPoint(LatLng pos) {
    points.add(pos);
    setState(() {});
  }

  addClearButton() {
    return points.length > 1 ? FloatingActionButton(
      onPressed: clearPoints,
      child: const Icon(Icons.clear),
      backgroundColor: CustomColors.colorHighlight,
    ) : null;
  }

  Scaffold getSettingsFragment() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? ''),
        backgroundColor: CustomColors.secondaryColor,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(95, 16, 16, 0),
              child: Text(AppLocalizations.of(context)?.localization ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: CustomColors.subPrimaryColor)))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.secondaryColor,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                onPressed: () {
                  changeLanguage('ru');
                },
                child: Text(AppLocalizations.of(context)?.russian ?? ''),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: CustomColors.secondaryColor,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                onPressed: () {
                  changeLanguage('en');
                },
                child: Text(AppLocalizations.of(context)?.english ?? ''),
              ))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 46),
                    primary: CustomColors.colorHighlight,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                onPressed: () {
                  logout();
                },
                child: Text(AppLocalizations.of(context)?.logout ?? ''),
              ))
        ])
      ]),
      bottomNavigationBar: getMenu(),
    );
  }

  void changeLanguage(String? language) async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') != language) {
      await prefs.setString('languageCode', language!);
      await prefs.setString('countryCode', language.toUpperCase());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
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

  BottomNavigationBar getMenu() {
    return BottomNavigationBar(
      key: Key('menu'),
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
          label: AppLocalizations.of(context)?.notes ?? '',
          icon: Icon(Icons.notes),
        ),
        BottomNavigationBarItem(
          label: AppLocalizations.of(context)?.map ?? '',
          icon: Icon(Icons.map),
        ),
        BottomNavigationBarItem(
          label: AppLocalizations.of(context)?.settings ?? '',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  Row getSubtitle(Task task) {
    return task.category.isNotEmpty
        ? Row(children: [
            Text(Helper.parseDateForCard(task.date),
                style: TextStyle(color: CustomColors.inputColor)),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
              child: Icon(Icons.bookmark, color: CustomColors.secondaryColor),
            ),
            Text(task.category,
                style: TextStyle(color: CustomColors.colorHighlight))
          ])
        : Row(children: [
            Text(Helper.parseDateForCard(task.date),
                style: TextStyle(color: CustomColors.inputColor))
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
            builder: (context) => EditWidget(
                  task: task,
                  categories: getCategories(),
                )));
  }

  void onFloatButtonClick() {
    if (isToAdd) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditWidget(
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
    return tasks
        .where((e) => e.category.isNotEmpty)
        .map((e) {
          return Helper.capitalizeString(e.category);
        })
        .toSet()
        .toList();
  }

  List<Task> getListByType(String type, List<Task> list) {
    switch (type) {
      case "1":
        return list
            .where((element) =>
                Helper.getDiffFromToday(element.date) < 0 &&
                !Helper.parseBool(element.done))
            .toList();
      case "2":
        return list
            .where((element) => Helper.getDiffFromToday(element.date) == 0)
            .toList();
      case "3":
        return list
            .where((element) => Helper.getDiffFromToday(element.date) == 1)
            .toList();
      case "4":
        return list.where((element) {
          var diffFromToday = Helper.getDiffFromToday(element.date);
          return diffFromToday > 1 && diffFromToday <= 7;
        }).toList();
      case "5":
        return list.where((element) {
          var diffFromToday = Helper.getDiffFromToday(element.date);
          return diffFromToday > 7 && diffFromToday <= 31;
        }).toList();
      case "6":
        return list.where((element) {
          var diffFromToday = Helper.getDiffFromToday(element.date);
          return diffFromToday > 31;
        }).toList();
      default:
        return list
            .where(
                (element) => Helper.capitalizeString(element.category) == type)
            .toList();
    }
  }
}
