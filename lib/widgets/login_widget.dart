import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ios_android_flutter/helpers/validation_errors.dart';
import 'package:ios_android_flutter/rest/apis.dart';
import 'package:ios_android_flutter/rest/retrofit.dart';

import '../helpers/theme.dart';
import 'main_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> {
  int _selectedIndex = 0;

  String? loginValid;
  String? passwordValid;
  String? repeatPasswordValid;
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginController.addListener(validateLogin);
    passwordController.addListener(validatePassword);
    repeatPasswordController.addListener(validateRepeatPassword);
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && passwordValid == ValidationErrors.passwordsNotEquals) {
        passwordValid = null;
        repeatPasswordValid = null;
      }
      _selectedIndex = index;
    });
  }

  void validateLogin() {
    String? validate =
        loginController.text.isNotEmpty ? null : ValidationErrors.required;
    if (validate != loginValid) {
      setState(() {
        loginValid = validate;
      });
    }
  }

  void validatePassword() {
    String? validate = passwordController.text.isNotEmpty
        ? ((_selectedIndex == 0 ||
                passwordController.text == repeatPasswordController.text)
            ? null
            : ValidationErrors.passwordsNotEquals)
        : ValidationErrors.required;
    if (validate != passwordValid) {
      setState(() {
        passwordValid = validate;
        if (_selectedIndex == 1 &&
            (validate == ValidationErrors.passwordsNotEquals ||
                validate == null)) {
          repeatPasswordValid = validate;
        }
      });
    }
  }

  void validateRepeatPassword() {
    String? validate = repeatPasswordController.text.isNotEmpty
        ? ((_selectedIndex == 0 ||
                passwordController.text == repeatPasswordController.text)
            ? null
            : ValidationErrors.passwordsNotEquals)
        : ValidationErrors.required;
    if (validate != repeatPasswordValid) {
      setState(() {
        repeatPasswordValid = validate;
        if (_selectedIndex == 1 &&
            (validate == ValidationErrors.passwordsNotEquals ||
                validate == null)) {
          passwordValid = validate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: OrientationBuilder(builder: (context, orientation) {
          return Stack(
            children: [
              SvgPicture.asset('assets/background.svg',
                  alignment: Alignment.center, fit: BoxFit.fill),
              getTemplate(orientation),
            ],
          );
        }));
  }

  Column getTemplate(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      if (_selectedIndex == 1) {
        var verticalRegister = Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)?.welcome ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 64,
                            color: CustomColors.primaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 10.0,
                                color: CustomColors.colorHighlight,
                              ),
                            ],
                          ))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                          AppLocalizations.of(context)?.loginFormSubtitle ?? '',
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.primaryColor))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(130, 46),
                        primary: CustomColors.colorHighlight,
                        textStyle: const TextStyle(fontSize: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.horizontal(left: Radius.circular(8)),
                        )),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    child: Text(AppLocalizations.of(context)?.loginForm ?? ''),
                  ))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 150, 16, 8),
                      child: TextField(
                        controller: loginController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: loginValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.loginHint ?? '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextField(
                        controller: passwordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: passwordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.passwordHint ??
                                    '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextField(
                        controller: repeatPasswordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: repeatPasswordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText: AppLocalizations.of(context)
                                    ?.repeatPasswordHint ??
                                '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
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
                      save(true);
                    },
                    child: Text(
                        AppLocalizations.of(context)?.registerButton ?? ''),
                  ))
            ])
          ],
        );
        return verticalRegister;
      } else {
        var verticalSign = Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)?.welcome ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 64,
                            color: CustomColors.primaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 10.0,
                                color: CustomColors.colorHighlight,
                              ),
                            ],
                          ))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                          AppLocalizations.of(context)?.loginFormSubtitle ?? '',
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.primaryColor))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 65),
                      child: ElevatedButton(
                        key: Key("toRegister"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(130, 46),
                            primary: CustomColors.colorHighlight,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8)),
                            )),
                        onPressed: () {
                          _onItemTapped(1);
                        },
                        child: Text(
                            AppLocalizations.of(context)?.registerButton ?? ''),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 150, 16, 8),
                      child: TextField(
                        controller: loginController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: loginValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            filled: true,
                            fillColor: Colors.white,
                            hintText:
                                AppLocalizations.of(context)?.loginHint ?? '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextField(
                        controller: passwordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: passwordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.passwordHint ??
                                    '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    key: Key("SignIn"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 46),
                        primary: CustomColors.secondaryColor,
                        textStyle: const TextStyle(fontSize: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                    onPressed: () {
                      save(false);
                    },
                    child: Text(AppLocalizations.of(context)?.loginForm ?? ''),
                  ))
            ])
          ],
        );
        return verticalSign;
      }
    } else {
      if (_selectedIndex == 1) {
        var horizontalRegister = Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 64, 4.0),
                      child: Text(AppLocalizations.of(context)?.welcome ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 64,
                            color: CustomColors.primaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 10.0,
                                color: CustomColors.colorHighlight,
                              ),
                            ],
                          ))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                          AppLocalizations.of(context)?.loginFormSubtitle ?? '',
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.primaryColor))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 0, 200, 4),
                      child: TextField(
                        controller: loginController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 8, height: 0.6),
                            //
                            suffixIcon: loginValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.loginHint ?? '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 4, 200, 4),
                      child: TextField(
                        controller: passwordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 8, height: 0.6),
                            suffixIcon: passwordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.passwordHint ??
                                    '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 4, 200, 4),
                      child: TextField(
                        controller: repeatPasswordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 8, height: 0.6),
                            suffixIcon: repeatPasswordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText: AppLocalizations.of(context)
                                    ?.repeatPasswordHint ??
                                '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 8, 8, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 46),
                            primary: CustomColors.primaryColor,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )),
                        onPressed: () {
                          _onItemTapped(0);
                        },
                        child:
                            Text(AppLocalizations.of(context)?.loginForm ?? ''),
                      ))),
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 200, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 46),
                            primary: CustomColors.colorHighlight,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )),
                        onPressed: () {
                          save(true);
                        },
                        child: Text(
                            AppLocalizations.of(context)?.registerButton ?? ''),
                      ))),
            ])
          ],
        );
        return horizontalRegister;
      } else {
        var horizontalSign = Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 64, 4.0),
                      child: Text(AppLocalizations.of(context)?.welcome ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 64,
                            color: CustomColors.primaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 10.0,
                                color: CustomColors.colorHighlight,
                              ),
                            ],
                          ))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                          AppLocalizations.of(context)?.loginFormSubtitle ?? '',
                          style: TextStyle(
                              fontSize: 20, color: CustomColors.primaryColor))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 32, 200, 4),
                      child: TextField(
                        controller: loginController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: loginValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.loginHint ?? '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 4, 200, 4),
                      child: TextField(
                        controller: passwordController,
                        autofocus: false,
                        obscureText: true,
                        style: TextStyle(
                            fontSize: 22.0, color: CustomColors.primaryColor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(fontSize: 16, height: 0.6),
                            suffixIcon: passwordValid == null
                                ? null
                                : Icon(Icons.error, color: Colors.red),
                            hintText:
                                AppLocalizations.of(context)?.passwordHint ??
                                    '',
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
                                  color: CustomColors.secondaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(200, 8, 8, 8),
                      child: ElevatedButton(
                        key: Key("toRegister"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 46),
                            primary: CustomColors.primaryColor,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )),
                        onPressed: () {
                          _onItemTapped(1);
                        },
                        child: Text(
                            AppLocalizations.of(context)?.registerButton ?? ''),
                      ))),
              Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 200, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 46),
                            primary: CustomColors.colorHighlight,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )),
                        onPressed: () {
                          save(false);
                        },
                        child:
                            Text(AppLocalizations.of(context)?.loginForm ?? ''),
                      )))
            ])
          ],
        );
        return horizontalSign;
      }
    }
  }

  void save(bool isRegister) {
    if (isRegister &&
        loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text == repeatPasswordController.text) {
      register(loginController.text, passwordController.text);
    } else if (!isRegister &&
        loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      auth(loginController.text, passwordController.text);
    }
  }

  void auth(String login, String password) {
    final client = ApiRequest(Dio(BaseOptions(contentType: "application/json")),
        baseUrl: Apis.baseUrl);
    client
        .signIn(login, password)
        .then((value) => _buildHasAccess(value.token));
  }

  void register(String login, String password) {
    final client = ApiRequest(Dio(BaseOptions(contentType: "application/json")),
        baseUrl: Apis.baseUrl);
    client
        .register(login, password)
        .then((value) => _buildHasAccess(value.token));
  }

  void _buildHasAccess(String token) {
    final client = ApiRequest(Dio(BaseOptions(contentType: "application/json")),
        baseUrl: Apis.baseUrl);
    client.hasAccess(token).then((value) => {
          if (value) {navigateToMain()}
        });
  }

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainWidget(needToWrap: false)),
    );
  }
}
