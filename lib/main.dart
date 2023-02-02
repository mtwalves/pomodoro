import 'package:flutter/material.dart';
import 'package:pomodoro/core/pomodoro.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';
import 'ui/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<Pomodoro>(
      create: (context) => Pomodoro(),
      child: MaterialApp(
        title: 'Pomodoro',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.red,
        ),
        routes: {
          '/': (context) => const MyHomePage(title: 'Pomodoro Timer'),
          '/settings': (context) => const Settings()
        },
      ),
    );
  }
}
