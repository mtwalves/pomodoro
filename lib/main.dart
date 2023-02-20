import 'package:flutter/material.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';
import 'package:pomodoro/core/bloc/timer/ticker.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/home.dart';
import 'ui/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final TimerBloc timerBloc = TimerBloc(ticker: const Ticker());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: timerBloc),
        BlocProvider(
          lazy: false,
          create: (context) => PomodoroBloc(timer: timerBloc),
        ),
      ],
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
