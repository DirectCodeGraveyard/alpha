part of alpha.tasks;

typedef void Task();

class TaskQueue {
  final List<Task> _high = [];
  final List<Task> _low = [];
  Timer _timer;
  
  TaskQueue();
  
  void add(Task task, [Priority priority = Priority.LOW]) {
    if (priority.urgent) {
      _high.insert(0, task);
    } else if (priority.high) {
      _high.add(task);
    } else {
      _low.add(task);
    }
  }
  
  void run() {
    while (_high.isNotEmpty) {
      _high.removeAt(0)();
    }
    
    while (_low.isNotEmpty) {
      _low.removeAt(0)();
    }
  }
  
  Future schedule() {
    return new Future(run);
  }
  
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
  
  void stop() {
    if (_timer == null) {
      throw "Queue was never started";
    }
    
    _timer.cancel();
    _timer = null;
  }
}

class Priority {
  static const Priority URGENT = const Priority(urgent: true);
  static const Priority HIGH = const Priority(high: true);
  static const Priority LOW = const Priority(low: true);
  
  final bool urgent;
  final bool high;
  final bool low;
  
  const Priority({this.urgent: false, this.low: false, this.high: false});
}