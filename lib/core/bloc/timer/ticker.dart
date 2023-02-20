class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) =>
      Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
          .take(ticks);
}
