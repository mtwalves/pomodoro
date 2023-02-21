part of 'pomodoro_bloc.dart';

abstract class PomodoroState extends Equatable {
  const PomodoroState({
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.longBreakInterval,
    required this.pomodorosCompleted,
  });

  final Duration pomodoroDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int longBreakInterval;
  final int pomodorosCompleted;

  @override
  List<Object> get props => [
        pomodoroDuration.inSeconds,
        shortBreakDuration.inSeconds,
        longBreakDuration.inSeconds,
        longBreakInterval
      ];
}

class PomodoroSet extends PomodoroState {
  const PomodoroSet({
    required super.pomodoroDuration,
    required super.shortBreakDuration,
    required super.longBreakDuration,
    required super.longBreakInterval,
    required super.pomodorosCompleted,
  });

  @override
  String toString() =>
      'PomodoroSet { pomodoroDuration: ${pomodoroDuration.inSeconds} }';
}

class PomodoroShortBreak extends PomodoroState {
  const PomodoroShortBreak({
    required super.pomodoroDuration,
    required super.shortBreakDuration,
    required super.longBreakDuration,
    required super.longBreakInterval,
    required super.pomodorosCompleted,
  });

  @override
  String toString() =>
      'PomodoroShortBreak { pomodoroDuration: ${pomodoroDuration.inSeconds} }';
}

class PomodoroLongBreak extends PomodoroState {
  const PomodoroLongBreak({
    required super.pomodoroDuration,
    required super.shortBreakDuration,
    required super.longBreakDuration,
    required super.longBreakInterval,
    required super.pomodorosCompleted,
  });

  @override
  String toString() =>
      'PomodoroLongBreak { pomodoroDuration: ${pomodoroDuration.inSeconds} }';
}
