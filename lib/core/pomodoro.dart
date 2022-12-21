import 'dart:async';

enum PomodoroState { pomodoro, shortBreak, longBreak }

class Pomodoro {
  Pomodoro({
    this.pomodoroDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.longBreakInterval = 4,
  });

  late Timer _timer;
  final Stopwatch _stopWatch = Stopwatch();
  int pomodorosCompleted = 0;
  int longBreakInterval;
  PomodoroState _state = PomodoroState.pomodoro;
  Duration pomodoroDuration;
  Duration shortBreakDuration;
  Duration longBreakDuration;

  Duration get _remainingPomodoro => pomodoroDuration - _stopWatch.elapsed;
  Duration get _remainingShortBreak => shortBreakDuration - _stopWatch.elapsed;
  Duration get _remainingLongBreak => longBreakDuration - _stopWatch.elapsed;
  Duration get remainingTime {
    if (_state == PomodoroState.shortBreak) return _remainingShortBreak;
    if (_state == PomodoroState.longBreak) return _remainingLongBreak;

    return _remainingPomodoro;
  }

  bool get isRunning => _stopWatch.isRunning;
  PomodoroState get state => _state;
  set state(PomodoroState newState) {
    _stopWatch.stop();
    _stopWatch.reset();
    _state = newState;
  }

  void start() {
    _stopWatch.start();
    _timer = Timer(remainingTime, _onTimerComplete);
  }

  void stop() {
    _stopWatch.stop();
    _timer.cancel();
  }

  void _onTimerComplete() {
    print('Time is up');

    _stopWatch.stop();
    _stopWatch.reset();
    if (_state == PomodoroState.pomodoro) {
      _onPomodoroComplete();
    } else {
      _onBreakComplete();
    }
  }

  void _onPomodoroComplete() {
    print('Pomodoro complete!');

    pomodorosCompleted += 1;
    if (pomodorosCompleted % longBreakInterval == 0) {
      _state = PomodoroState.longBreak;
    } else {
      _state = PomodoroState.shortBreak;
    }
  }

  void _onBreakComplete() {
    print('Break complete!');

    _state = PomodoroState.pomodoro;
  }
}
