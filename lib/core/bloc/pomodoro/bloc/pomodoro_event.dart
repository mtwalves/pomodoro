part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object> get props => [];
}

class PomodoroSetPressed extends PomodoroEvent {}

class PomodoroShortBreakPressed extends PomodoroEvent {}

class PomodoroLongBreakPressed extends PomodoroEvent {}

class PomodoroTimerStart extends PomodoroEvent {}

class PomodoroTimerStop extends PomodoroEvent {}

class PomodoroCompleted extends PomodoroEvent {}

class PomodoroBreakCompleted extends PomodoroEvent {}

class PomodoroSkipNext extends PomodoroEvent {}

class PomodoroSettings extends PomodoroEvent {
  const PomodoroSettings({
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.longBreakInterval,
  });

  final Duration pomodoroDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int longBreakInterval;

  @override
  List<Object> get props => [
        pomodoroDuration.inSeconds,
        shortBreakDuration.inSeconds,
        longBreakDuration.inSeconds,
        longBreakInterval
      ];
}
