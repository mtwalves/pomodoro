import 'dart:async';

import 'package:flutter/foundation.dart';

enum PomodoroState { pomodoro, shortBreak, longBreak }

class Pomodoro {
  Pomodoro({
    this.pomodoroDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.longBreakInterval = 4,
  });

  int pomodorosCompleted = 0;
  int longBreakInterval;
  Duration pomodoroDuration;
  Duration shortBreakDuration;
  Duration longBreakDuration;

  bool get isRunning => stopWatch.isRunning;
  PomodoroState get state => _state;

  set state(PomodoroState newState) {
    stopWatch.stop();
    stopWatch.reset();
    _state = newState;
  }

  void start() {
    stopWatch.start();
    timer = Timer(remainingTime, _onTimerComplete);
  }

  void stop() {
    stopWatch.stop();
    timer.cancel();
  }

  @visibleForTesting
  late Timer timer;
  @visibleForTesting
  final Stopwatch stopWatch = Stopwatch();
  PomodoroState _state = PomodoroState.pomodoro;
  Duration get _remainingPomodoro => pomodoroDuration - stopWatch.elapsed;
  Duration get _remainingShortBreak => shortBreakDuration - stopWatch.elapsed;
  Duration get _remainingLongBreak => longBreakDuration - stopWatch.elapsed;
  Duration get remainingTime {
    if (_state == PomodoroState.shortBreak) return _remainingShortBreak;
    if (_state == PomodoroState.longBreak) return _remainingLongBreak;

    return _remainingPomodoro;
  }

  void _onTimerComplete() {
    debugPrint('Time is up');

    stopWatch.stop();
    stopWatch.reset();
    if (_state == PomodoroState.pomodoro) {
      _onPomodoroComplete();
    } else {
      _onBreakComplete();
    }
  }

  void _onPomodoroComplete() {
    debugPrint('Pomodoro complete!');

    pomodorosCompleted += 1;
    if (pomodorosCompleted % longBreakInterval == 0) {
      _state = PomodoroState.longBreak;
    } else {
      _state = PomodoroState.shortBreak;
    }
  }

  void _onBreakComplete() {
    debugPrint('Break complete!');

    _state = PomodoroState.pomodoro;
  }
}
