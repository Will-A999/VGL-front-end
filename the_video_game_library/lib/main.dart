import 'package:flutter/material.dart';
import 'components/login.dart';
import 'components/signup.dart';
import 'components/app-container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/signup': (context) => Signup(),
        '/app': (context) => AppContainer()
      },
    );
  }
}


