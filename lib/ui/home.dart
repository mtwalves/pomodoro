import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';
import 'package:pomodoro/ui/widgets/timer_buttons.dart';
import 'package:pomodoro/ui/widgets/timer_circle.dart';
import 'package:pomodoro/ui/widgets/toggle_menu.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();

  void onItemTapped(int index, BuildContext context) {
    PomodoroEvent event = PomodoroSetPressed();

    if (index == 1) {
      event = PomodoroShortBreakPressed();
    } else if (index == 2) {
      event = PomodoroLongBreakPressed();
    }

    context.read<PomodoroBloc>().add(event);
  }

  int getCurrentIndex(PomodoroState state) {
    if (state is PomodoroShortBreak) return 1;
    if (state is PomodoroLongBreak) return 2;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 650;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state is TimerRunComplete) {
            player.play(AssetSource('sounds/analog-alarm-clock.wav'));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (isLargeScreen) const ToggleMenu(),
                const SizedBox(height: 50),
                const TimerCircle(),
                const SizedBox(height: 50),
                const TimerButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: isLargeScreen
          ? null
          : BlocBuilder<PomodoroBloc, PomodoroState>(
              builder: (context, state) => BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timer),
                    label: 'Pomodoro',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.snooze),
                    label: 'Short Break',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.snooze),
                    label: 'Long Break',
                  ),
                ],
                onTap: (value) => onItemTapped(value, context),
                currentIndex: getCurrentIndex(state),
              ),
            ),
    );
  }
}
