import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';
import 'package:pomodoro/ui/widgets/pomodoros_completed.dart';

class TimerCircle extends StatelessWidget {
  const TimerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final int duration =
        context.select((TimerBloc bloc) => bloc.state.duration);
    final String minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final String secondsStr =
        (duration % 60).floor().toString().padLeft(2, '0');

    final double percentage =
        context.select((PomodoroBloc bloc) => bloc.percentage);

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 1,
            widthFactor: 1,
            child: CircularProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$minutesStr:$secondsStr',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.merge(const TextStyle(color: Colors.white)),
                ),
                const PomodorosCompleted()
              ],
            ),
          )
        ],
      ),
    );
  }
}
