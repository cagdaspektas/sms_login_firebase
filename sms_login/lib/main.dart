import 'package:flutter/material.dart';
import 'package:sms_login/feature/authScreenMobx/view/auth_screen_mobx_view.dart';
import 'package:sms_login/feature/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AuthScreenViewMobx(),
    );
  }
}
