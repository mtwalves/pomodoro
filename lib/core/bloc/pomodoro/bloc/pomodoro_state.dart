part of 'pomodoro_bloc.dart';

abstract class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object> get props => [];
}

class PomodoroInitial extends PomodoroState {}

class PomodoroSet extends PomodoroState {}

class PomodoroShortBreak extends PomodoroState {}

class PomodoroLongBreak extends PomodoroState {}
