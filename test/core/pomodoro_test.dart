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

    group('updates timers', () {
      group('pomodoro', () {
        test('should reset when timer is updated and is on pomodoro state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            pomodoroDuration: const Duration(seconds: 60),
          );

          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.pomodoroDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, false);
          expect(pomodoro.stopWatch.elapsedMilliseconds, 0);
        });

        test(
            'should NOT reset when timer is updated and is NOT on pomodoro state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            pomodoroDuration: const Duration(seconds: 60),
          );
          pomodoro.state = PomodoroState.shortBreak;
          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.pomodoroDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, true);
          expect(pomodoro.stopWatch.elapsed,
              greaterThanOrEqualTo(const Duration(seconds: 1)));
        });
      });

      group('short break', () {
        test('should reset when timer is updated and is on short break state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            shortBreakDuration: const Duration(seconds: 60),
          );
          pomodoro.state = PomodoroState.shortBreak;
          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.shortBreakDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, false);
          expect(pomodoro.stopWatch.elapsedMilliseconds, 0);
        });

        test(
            'should NOT reset when timer is updated and is NOT on short break state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            shortBreakDuration: const Duration(seconds: 60),
          );
          pomodoro.state = PomodoroState.longBreak;
          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.shortBreakDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, true);
          expect(pomodoro.stopWatch.elapsed,
              greaterThanOrEqualTo(const Duration(seconds: 1)));
        });
      });

      group('long break', () {
        test('should reset when timer is updated and is on long break state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            longBreakDuration: const Duration(seconds: 60),
          );
          pomodoro.state = PomodoroState.longBreak;
          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.longBreakDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, false);
          expect(pomodoro.stopWatch.elapsedMilliseconds, 0);
        });

        test(
            'should NOT reset when timer is updated and is NOT on long break state',
            () async {
          Pomodoro pomodoro = Pomodoro(
            longBreakDuration: const Duration(seconds: 60),
          );
          pomodoro.state = PomodoroState.pomodoro;
          pomodoro.start();
          await Future.delayed(const Duration(seconds: 1));
          pomodoro.longBreakDuration = const Duration(seconds: 120);

          expect(pomodoro.stopWatch.isRunning, true);
          expect(pomodoro.stopWatch.elapsed,
              greaterThanOrEqualTo(const Duration(seconds: 1)));
        });
      });
    });

    group('remaining time', () {
      test('seconds should be correct', () {
        Pomodoro pomodoro =
            Pomodoro(pomodoroDuration: const Duration(seconds: 1));
        expect(pomodoro.remainingTimeText, '00:01');

        pomodoro.pomodoroDuration = const Duration(seconds: 50);
        expect(pomodoro.remainingTimeText, '00:50');
      });

      test('minutes should be correct', () {
        Pomodoro pomodoro =
            Pomodoro(pomodoroDuration: const Duration(minutes: 1));
        expect(pomodoro.remainingTimeText, '01:00');

        pomodoro.pomodoroDuration = const Duration(minutes: 50);
        expect(pomodoro.remainingTimeText, '50:00');

        pomodoro.pomodoroDuration = const Duration(minutes: 90);
        expect(pomodoro.remainingTimeText, '90:00');
      });
    });

    group('on timer complete callback', () {
      test('should execute callback when timer is complete', () async {
        bool wasCalled = false;
        Pomodoro pomodoro = Pomodoro(
            pomodoroDuration: const Duration(seconds: 1),
            onTimerComplete: () {
              wasCalled = true;
            });

        pomodoro.start();
        await Future.delayed(const Duration(seconds: 1));

        expect(wasCalled, true);
      });
    });
  });
}
