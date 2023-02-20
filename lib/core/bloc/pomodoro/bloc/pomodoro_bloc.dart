import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  PomodoroBloc({
    required this.timer,
    Duration pomodoroDuration = const Duration(minutes: 25),
    Duration shortBreakDuration = const Duration(minutes: 5),
    Duration longBreakDuration = const Duration(minutes: 15),
    this.longBreakInterval = 4,
  }) : super(PomodoroInitial()) {
    _pomodoroDuration = pomodoroDuration;
    _shortBreakDuration = shortBreakDuration;
    _longBreakDuration = longBreakDuration;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      emit(PomodoroSet());
      _resetTimer(_pomodoroDuration);
    });

    timer.stream.listen((event) {
      print(event);
      if (event is TimerRunComplete) _onTimerComplete(emit);
    });

    on<PomodoroSetPressed>((event, emit) => _onPomodoro(emit));
    on<PomodoroShortBreakPressed>((event, emit) => _onShortBreak(emit));
    on<PomodoroLongBreakPressed>((event, emit) => _onLongBreak(emit));
    on<PomodoroTimerStart>((event, emit) {
      TimerEvent event =
          timer.state is TimerInitial || timer.state is TimerRunComplete
              ? const TimerStarted()
              : const TimerResumed();
      timer.add(event);
    });
    on<PomodoroTimerStop>((event, emit) {
      timer.add(const TimerPaused());
    });
  }

  final TimerBloc timer;
  int pomodorosCompleted = 0;
  int longBreakInterval;
  late Duration _pomodoroDuration;
  late Duration _shortBreakDuration;
  late Duration _longBreakDuration;

  bool get isLoading => state is PomodoroInitial;

  Duration get pomodoroDuration => _pomodoroDuration;
  set pomodoroDuration(Duration duration) {
    if (state is PomodoroSet) {
      _resetTimer(duration);
    }
    _pomodoroDuration = duration;
  }

  Duration get shortBreakDuration => _shortBreakDuration;
  set shortBreakDuration(Duration duration) {
    if (state is PomodoroShortBreak) {
      _resetTimer(duration);
    }
    _shortBreakDuration = duration;
  }

  Duration get longBreakDuration => _longBreakDuration;
  set longBreakDuration(Duration duration) {
    if (state is PomodoroLongBreak) {
      _resetTimer(duration);
    }
    _longBreakDuration = duration;
  }

  void _resetTimer(Duration duration) {
    timer.add(TimerReset(duration: duration.inSeconds));
  }

  void _onShortBreak(emit) {
    _resetTimer(_shortBreakDuration);
    emit(PomodoroShortBreak());
  }

  void _onLongBreak(emit) {
    _resetTimer(_longBreakDuration);
    emit(PomodoroLongBreak());
  }

  void _onPomodoro(emit) {
    _resetTimer(_pomodoroDuration);
    emit(PomodoroSet());
  }

  void _onTimerComplete(emit) {
    if (state is PomodoroSet) {
      pomodorosCompleted += 1;
      if (pomodorosCompleted % longBreakInterval == 0) {
        _onLongBreak(emit);
      } else {
        _onShortBreak(emit);
      }
    } else {
      _onPomodoro(emit);
    }
  }
}
