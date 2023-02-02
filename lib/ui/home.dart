import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/pomodoro.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer =
        Timer.periodic(const Duration(seconds: 1), ((_) => setState(() {})));
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  // TODO: Add tests for this function (bug when minutes > 60)
  String remainingTime(Pomodoro pomodoro) {
    Duration remaining = pomodoro.remainingTime;
    String minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

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
      body: Consumer<Pomodoro>(
        builder: (context, pomodoro, child) => Center(
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
                  ToggleButtons(
                      isSelected: [
                        pomodoro.state == PomodoroState.pomodoro,
                        pomodoro.state == PomodoroState.shortBreak,
                        pomodoro.state == PomodoroState.longBreak,
                      ],
                      onPressed: (int index) {
                        setState(() {
                          pomodoro.state = PomodoroState.values[index];
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                      ]),
                  const SizedBox(height: 20),
                  Text(
                    remainingTime(pomodoro),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        if (pomodoro.isRunning) {
                          pomodoro.stop();
                        } else {
                          pomodoro.start();
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 50),
                        ),
                      ),
                      child: Text(
                        pomodoro.isRunning ? 'STOP' : 'START',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  const SizedBox(height: 20),
                  Text('#${pomodoro.pomodorosCompleted}')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
