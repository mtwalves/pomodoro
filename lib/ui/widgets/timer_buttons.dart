import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';

class TimerButtons extends StatelessWidget {
  const TimerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select((TimerBloc bloc) => bloc.isRunning);
    final PomodoroBloc pomodoro = context.read<PomodoroBloc>();
    final ColorScheme colors = Theme.of(context).colorScheme;
    final ButtonStyle style = IconButton.styleFrom(
      foregroundColor: colors.onPrimary,
      backgroundColor: colors.primary,
      disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
      hoverColor: colors.onPrimary.withOpacity(0.08),
      focusColor: colors.onPrimary.withOpacity(0.12),
      highlightColor: colors.onPrimary.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
    );

    void onPlayPause() {
      if (isRunning) {
        pomodoro.add(PomodoroTimerStop());
      } else {
        pomodoro.add(PomodoroTimerStart());
      }
    }

    void onSkipNext() {
      pomodoro.add(PomodoroSkipNext());
    }

    void onSettings() {
      Navigator.of(context).pushNamed('/settings');
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onPlayPause,
              style: style,
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
            ),
            if (isRunning) ...[
              const SizedBox(width: 10),
              IconButton(
                onPressed: onSkipNext,
                style: style,
                icon: const Icon(Icons.skip_next),
              )
            ]
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onSettings,
              style: style,
              icon: const Icon(Icons.settings),
            ),
          ],
        )
      ],
    );
  }
}
