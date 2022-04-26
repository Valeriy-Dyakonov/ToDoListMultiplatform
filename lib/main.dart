import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ios_android_flutter/widgets/main_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppLocalizations.of(context)?.appName ?? '',
        theme:
            ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SafeArea(child: MainWidget()));
  }
}
