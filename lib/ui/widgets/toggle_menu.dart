import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';

class ToggleMenu extends StatelessWidget {
  const ToggleMenu({super.key});

  void onPressed(int index, BuildContext context) {
    PomodoroEvent event = PomodoroSetPressed();
    if (index == 1) {
      event = PomodoroShortBreakPressed();
    } else if (index == 2) {
      event = PomodoroLongBreakPressed();
    }

    context.read<PomodoroBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return ToggleButtons(
            isSelected: [
              state is PomodoroSet,
              state is PomodoroShortBreak,
              state is PomodoroLongBreak,
            ],
            onPressed: (int index) => onPressed(index, context),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedColor: Colors.white,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 64.0,
              minWidth: 200.0,
            ),
            textStyle: Theme.of(context).textTheme.headlineSmall,
            children: const [
              Text('Pomodoro'),
              Text('Short Break'),
              Text('Long Break')
            ]);
      },
    );
  }
}
