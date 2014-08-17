part of alpha.async;

/**
 * A Task Function
 */
typedef void Task();

/**
 * A Task Queue. Allows a prioritized way to execute tasks.
 */
class TaskQueue {
  final List<Task> _high = [];
  final List<Task> _low = [];
  Timer _timer;
  
  /**
   * Creates a Task Queue
   */
  TaskQueue();
  
  /**
   * Adds the specified [task] to the queue with the optional [priority].
   */
  void add(Task task, [Priority priority = Priority.LOW]) {
    if (priority.urgent) {
      _high.insert(0, task);
    } else if (priority.high) {
      _high.add(task);
    } else {
      _low.add(task);
    }
  }
  
  /**
   * Synchronously executes the queue.
   */
  void run() {
    while (_high.isNotEmpty) {
      _high.removeAt(0)();
    }
    
    while (_low.isNotEmpty) {
      _low.removeAt(0)();
    }
  }
  
  /**
   * Schedules the queue as a future.
   */
  Future schedule() {
    return new Future(run);
  }
  
  /**
   * Starts a timer that executes the queue with an interval of [checkInterval] milliseconds.
   */
  void start([int checkInterval = 1]) {
    
    if (_timer != null) {
      throw "Queue already started";
    }
    
    var running = false;
    
    _timer = new Timer.periodic(new Duration(milliseconds: checkInterval), (timer) {
      if (running) return;
      running = true;
      run();
      running = false;
    });
  }
  
  /**
   * Stops the timer that executes the queue.
   */
  void stop() {
    if (_timer == null) {
      throw "Queue was never started";
    }
    
    _timer.cancel();
    _timer = null;
  }
}

/**
 * A Task Priority
 * 
 * [URGENT] is first, then [HIGH], and last [LOW].
 */
class Priority {
  static const Priority URGENT = const Priority(urgent: true);
  static const Priority HIGH = const Priority(high: true);
  static const Priority LOW = const Priority(low: true);
  
  final bool urgent;
  final bool high;
  final bool low;
  
  const Priority({this.urgent: false, this.low: false, this.high: false});
}