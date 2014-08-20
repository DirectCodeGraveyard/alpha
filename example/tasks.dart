import "package:alpha/async.dart";

void main() {
  var queue = new TaskQueue();
  queue.add(() {
    print("World");
  });
  
  queue.add(() {
    print("Hello");
  }, Priority.HIGH);
  
  queue.schedule();
}