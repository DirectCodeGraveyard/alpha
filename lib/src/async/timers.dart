part of alpha.async;

class TimedEntry<T> {

  Timer _timer;
  final T value;

  TimedEntry(T this.value);

  TimedEntry<T> start(int dur, void handleTimeout()) {
    _timer = new Timer(new Duration(seconds: dur), handleTimeout);
    return this;
  }
}
