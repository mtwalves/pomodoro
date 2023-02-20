import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/bloc/pomodoro/bloc/pomodoro_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late PomodoroBloc pomodoro;

  final formKey = GlobalKey<FormState>();
  final pomodoroController = TextEditingController();
  final shortBreakController = TextEditingController();
  final longBreakController = TextEditingController();
  final longBreakIntervalController = TextEditingController();
  @override
  void initState() {
    super.initState();

    pomodoro = context.read<PomodoroBloc>();
    pomodoroController.text = pomodoro.pomodoroDuration.inMinutes.toString();
    shortBreakController.text =
        pomodoro.shortBreakDuration.inMinutes.toString();
    longBreakController.text = pomodoro.longBreakDuration.inMinutes.toString();
    longBreakIntervalController.text = pomodoro.longBreakInterval.toString();
  }

  void onSubmit() {
    Duration pomodoroDuration =
        Duration(minutes: int.parse(pomodoroController.text));
    Duration shortBreakDuration =
        Duration(minutes: int.parse(shortBreakController.text));
    Duration longBreakDuration =
        Duration(minutes: int.parse(longBreakController.text));
    int longBreakInterval = int.parse(longBreakIntervalController.text);

    pomodoro.add(PomodoroSettings(
      pomodoroDuration: pomodoroDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakDuration: longBreakDuration,
      longBreakInterval: longBreakInterval,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('Time'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: pomodoroController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          label: Text('Pomodoro'),
                          suffix: Text('min'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: shortBreakController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          label: Text('Short Break'),
                          suffix: Text('min'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: longBreakController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          label: Text('Long Break'),
                          suffix: Text('min'),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Long break interval'),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: longBreakIntervalController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
