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
