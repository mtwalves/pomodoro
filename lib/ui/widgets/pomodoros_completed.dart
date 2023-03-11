import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';

class PomodorosCompleted extends StatelessWidget {
  const PomodorosCompleted({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int number =
        context.select((PomodoroBloc bloc) => bloc.pomodorosCompleted);

    return Text(
      '#$number',
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.merge(const TextStyle(color: Colors.white)),
    );
  }
}
