import "package:alpha/async.dart";

void main() {
  chain([sayHello, sayWut]);
}

void sayHello() {
  print("Hello World");
}

void sayWut() {
  print("Wut");
}
