import 'package:pomodoro/core/pomodoro.dart';
import 'package:test/test.dart';

void main() {
  group('Pomodoro', () {
    group('state', () {
      Pomodoro pomodoro = Pomodoro(
        pomodoroDuration: const Duration(seconds: 1),
        shortBreakDuration: const Duration(seconds: 1),
        longBreakInterval: 2,
      );

      test('should change to SHORT BREAK when POMODORO is done', () async {
        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));
        expect(pomodoro.pomodorosCompleted, 1);
        expect(pomodoro.state, PomodoroState.shortBreak);
      });

      test('should change to POMODORO when SHORT BREAK is done', () async {
        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));
        expect(pomodoro.state, PomodoroState.pomodoro);
      });

      test(
          'should change to LONG BREAK when POMODORO is done and LONG BREAK INTERVAL is done',
          () async {
        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));
        expect(pomodoro.pomodorosCompleted, 2);
        expect(pomodoro.state, PomodoroState.longBreak);
      });
    });

    group('stopwatch', () {
      test('should reset when state changes', () async {
        Pomodoro pomodoro = Pomodoro(
          pomodoroDuration: const Duration(seconds: 1),
        );

        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));
        expect(pomodoro.stopWatch.isRunning, false);
        expect(pomodoro.stopWatch.elapsedMilliseconds, 0);
      });

      test('should keep time if is paused and then resumed', () async {
        Pomodoro pomodoro = Pomodoro(
          pomodoroDuration: const Duration(seconds: 5),
        );

        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));
        pomodoro.stop();
        expect(pomodoro.stopWatch.elapsed,
            greaterThanOrEqualTo(const Duration(seconds: 1)));
      });
    });
  });
}
