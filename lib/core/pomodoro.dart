import 'dart:async';

import 'package:flutter/foundation.dart';

enum PomodoroStateOld { pomodoro, shortBreak, longBreak }

class Pomodoro {
  Pomodoro({
    pomodoroDuration = const Duration(minutes: 25),
    shortBreakDuration = const Duration(minutes: 5),
    longBreakDuration = const Duration(minutes: 15),
    this.longBreakInterval = 4,
    this.onTimerComplete,
  }) {
    _pomodoroDuration = pomodoroDuration;
    _shortBreakDuration = shortBreakDuration;
    _longBreakDuration = longBreakDuration;
  }

  int pomodorosCompleted = 0;
  int longBreakInterval;
  late Duration _pomodoroDuration;
  late Duration _shortBreakDuration;
  late Duration _longBreakDuration;
  void Function()? onTimerComplete;

  Duration get pomodoroDuration => _pomodoroDuration;
  set pomodoroDuration(Duration duration) {
    if (state == PomodoroStateOld.pomodoro) _reset();
    _pomodoroDuration = duration;
  }

  Duration get shortBreakDuration => _shortBreakDuration;
  set shortBreakDuration(Duration duration) {
    if (state == PomodoroStateOld.shortBreak) _reset();
    _shortBreakDuration = duration;
  }

  Duration get longBreakDuration => _longBreakDuration;
  set longBreakDuration(Duration duration) {
    if (state == PomodoroStateOld.longBreak) _reset();
    _longBreakDuration = duration;
  }

  PomodoroStateOld get state => _state;
  set state(PomodoroStateOld newState) {
    _reset();
    _state = newState;
  }

  bool get isRunning => stopWatch.isRunning;

  Duration get remainingTime {
    if (_state == PomodoroStateOld.shortBreak) return _remainingShortBreak;
    if (_state == PomodoroStateOld.longBreak) return _remainingLongBreak;

    return _remainingPomodoro;
  }

  String get remainingTimeText {
    String minutes = (remainingTime.inMinutes).toString().padLeft(2, '0');
    String seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void start() {
    stopWatch.start();
    timer = Timer(remainingTime, _onTimerComplete);
  }

  void stop() {
    stopWatch.stop();
    timer.cancel();
  }

  void toggle() {
    if (isRunning) {
      stop();
    } else {
      start();
    }
  }

  // --- Private variables and functions ---
  @visibleForTesting
  late Timer timer;
  @visibleForTesting
  final Stopwatch stopWatch = Stopwatch();
  PomodoroStateOld _state = PomodoroStateOld.pomodoro;
  Duration get _remainingPomodoro => pomodoroDuration - stopWatch.elapsed;
  Duration get _remainingShortBreak => shortBreakDuration - stopWatch.elapsed;
  Duration get _remainingLongBreak => longBreakDuration - stopWatch.elapsed;

  void _onTimerComplete() {
    debugPrint('Time is up');
    if (onTimerComplete != null) {
      onTimerComplete!();
    }
    _reset();
    if (_state == PomodoroStateOld.pomodoro) {
      _onPomodoroComplete();
    } else {
      _onBreakComplete();
    }
  }

  void _onPomodoroComplete() {
    debugPrint('Pomodoro complete!');

    pomodorosCompleted += 1;
    if (pomodorosCompleted % longBreakInterval == 0) {
      _state = PomodoroStateOld.longBreak;
    } else {
      _state = PomodoroStateOld.shortBreak;
    }
  }

  void _onBreakComplete() {
    debugPrint('Break complete!');

    _state = PomodoroStateOld.pomodoro;
  }

  void _reset() {
    stopWatch.stop();
    stopWatch.reset();
  }
}
