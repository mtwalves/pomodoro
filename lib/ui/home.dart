import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';

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
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
          )
        ],
      ),
      backgroundColor: Colors.redAccent,
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state is TimerRunComplete) {
            player.play(AssetSource('sounds/analog-alarm-clock.wav'));
          }
        },
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BlocBuilder<PomodoroBloc, PomodoroState>(
                    builder: (context, state) {
                      return ToggleButtons(
                          isSelected: [
                            state is PomodoroSet,
                            state is PomodoroShortBreak,
                            state is PomodoroLongBreak,
                          ],
                          onPressed: (int index) {
                            PomodoroEvent event = PomodoroSetPressed();
                            if (index == 1) {
                              event = PomodoroShortBreakPressed();
                            } else if (index == 2) {
                              event = PomodoroLongBreakPressed();
                            }

                            context.read<PomodoroBloc>().add(event);
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.red[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.red[200],
                          color: Colors.red[400],
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          children: const [
                            Text('Pomodoro'),
                            Text('Short Break'),
                            Text('Long Break')
                          ]);
                    },
                  ),
                  const SizedBox(height: 20),
                  const TimerText(),
                  const SizedBox(height: 20),
                  const TimerButton(),
                  const SizedBox(height: 20),
                  const PomodorosCompleted(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PomodorosCompleted extends StatelessWidget {
  const PomodorosCompleted({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int number =
        context.select((PomodoroBloc bloc) => bloc.pomodorosCompleted);

    return Text('#$number');
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}

class TimerButton extends StatelessWidget {
  const TimerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select((TimerBloc bloc) => bloc.isRunning);
    final PomodoroBloc pomodoro = context.read<PomodoroBloc>();

    return ElevatedButton(
        onPressed: () {
          if (isRunning) {
            pomodoro.add(PomodoroTimerStop());
          } else {
            pomodoro.add(PomodoroTimerStart());
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          ),
        ),
        child: Text(
          isRunning ? 'STOP' : 'START',
          style: Theme.of(context).textTheme.titleLarge,
        ));
  }
}
