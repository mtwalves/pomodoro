import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
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
              children: const <Widget>[
                ToggleMenu(),
                SizedBox(height: 50),
                TimerCircle(),
                SizedBox(height: 50),
                TimerButtons(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
