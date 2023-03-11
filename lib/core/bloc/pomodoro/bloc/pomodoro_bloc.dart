import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pomodoro/core/bloc/timer/timer_bloc.dart';

part 'pomodoro_event.dart';
part 'pomodoro_state.dart';

class PomodoroBloc extends HydratedBloc<PomodoroEvent, PomodoroState> {
  PomodoroBloc({
    required this.timer,
  }) : super(const PomodoroSet(
          pomodoroDuration: Duration(minutes: 25),
          shortBreakDuration: Duration(minutes: 5),
          longBreakDuration: Duration(minutes: 15),
          longBreakInterval: 4,
          pomodorosCompleted: 0,
        )) {
    timer.stream.listen((event) {
      if (event is TimerRunComplete) {
        _goToNextState();
      }
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
    on<PomodoroSettings>((event, emit) {
      if (state is PomodoroSet) {
        emit(PomodoroSet(
          pomodoroDuration: event.pomodoroDuration,
          longBreakDuration: event.longBreakDuration,
          shortBreakDuration: event.shortBreakDuration,
          longBreakInterval: event.longBreakInterval,
          pomodorosCompleted: state.pomodorosCompleted,
        ));
      } else if (state is PomodoroShortBreak) {
        emit(PomodoroShortBreak(
          pomodoroDuration: event.pomodoroDuration,
          longBreakDuration: event.longBreakDuration,
          shortBreakDuration: event.shortBreakDuration,
          longBreakInterval: event.longBreakInterval,
          pomodorosCompleted: state.pomodorosCompleted,
        ));
      } else if (state is PomodoroLongBreak) {
        emit(PomodoroLongBreak(
          pomodoroDuration: event.pomodoroDuration,
          longBreakDuration: event.longBreakDuration,
          shortBreakDuration: event.shortBreakDuration,
          longBreakInterval: event.longBreakInterval,
          pomodorosCompleted: state.pomodorosCompleted,
        ));
      }
    });
    on<PomodoroCompleted>((event, emit) {
      int pomodorosCompleted = state.pomodorosCompleted + 1;
      if (pomodorosCompleted % longBreakInterval == 0) {
        _onLongBreak(emit, pomodorosCompleted: true);
      } else {
        _onShortBreak(emit, pomodorosCompleted: true);
      }
    });
    on<PomodoroBreakCompleted>((event, emit) {
      _onPomodoro(emit);
    });
    on<PomodoroSkipNext>((event, emit) {
      _goToNextState();
    });
  }

  @override
  void onChange(Change<PomodoroState> change) {
    late Duration duration;
    if (change.nextState is PomodoroSet) {
      duration = change.nextState.pomodoroDuration;
    } else if (change.nextState is PomodoroShortBreak) {
      duration = change.nextState.shortBreakDuration;
    } else if (change.nextState is PomodoroLongBreak) {
      duration = change.nextState.longBreakDuration;
    }
    _resetTimer(duration);
    super.onChange(change);
  }

  final TimerBloc timer;

  int get pomodorosCompleted => state.pomodorosCompleted;

  int get longBreakInterval => state.longBreakInterval;

  Duration get pomodoroDuration => state.pomodoroDuration;

  Duration get shortBreakDuration => state.shortBreakDuration;

  Duration get longBreakDuration => state.longBreakDuration;

  Duration get duration => state.duration;

  double get percentage =>
      ((duration.inSeconds - timer.state.duration) / duration.inSeconds);

  void _resetTimer(Duration duration) {
    timer.add(TimerReset(duration: duration.inSeconds));
  }

  void _onShortBreak(emit, {pomodorosCompleted = false}) {
    emit(PomodoroShortBreak(
      pomodoroDuration: pomodoroDuration,
      longBreakDuration: longBreakDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakInterval: longBreakInterval,
      pomodorosCompleted:
          state.pomodorosCompleted + (pomodorosCompleted ? 1 : 0),
    ));
  }

  void _onLongBreak(emit, {pomodorosCompleted = false}) {
    emit(PomodoroLongBreak(
      pomodoroDuration: pomodoroDuration,
      longBreakDuration: longBreakDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakInterval: longBreakInterval,
      pomodorosCompleted:
          state.pomodorosCompleted + (pomodorosCompleted ? 1 : 0),
    ));
  }

  void _onPomodoro(emit) {
    emit(PomodoroSet(
      pomodoroDuration: pomodoroDuration,
      longBreakDuration: longBreakDuration,
      shortBreakDuration: shortBreakDuration,
      longBreakInterval: longBreakInterval,
      pomodorosCompleted: state.pomodorosCompleted,
    ));
  }

  void _goToNextState() {
    if (state is PomodoroSet) {
      add(PomodoroCompleted());
    } else {
      add(PomodoroBreakCompleted());
    }
  }

  @override
  PomodoroState? fromJson(Map<String, dynamic> json) {
    Duration pomodoroDuration = Duration(seconds: json['pomodoroDuration']);
    _resetTimer(pomodoroDuration);

    return PomodoroSet(
      pomodoroDuration: pomodoroDuration,
      shortBreakDuration: Duration(seconds: json['shortBreakDuration']),
      longBreakDuration: Duration(seconds: json['longBreakDuration']),
      longBreakInterval: json['longBreakInterval'] ?? 4,
      pomodorosCompleted: 0,
    );
  }

  @override
  Map<String, dynamic>? toJson(PomodoroState state) => {
        'pomodoroDuration': state.pomodoroDuration.inSeconds,
        'shortBreakDuration': state.shortBreakDuration.inSeconds,
        'longBreakDuration': state.longBreakDuration.inSeconds,
        'longBreakInterval': state.longBreakInterval,
      };
}
