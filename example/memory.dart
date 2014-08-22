import "package:alpha/core.dart";

void main() {
  var lists = [];
  var counter = 0;
  try {
    for (var i in range(1, 9999999)) {
      i++;
      lists.add(range(0, i));
      if ((i % 500) == 0) {
        print("Progress: ${i}");
      }
    }
  } on OutOfMemoryError catch (e) {
    print("Successfully Ran out of Memory. Clearing some space.");
    lists.clear();
    var something = [];
    something.add("Epic Success.");
    print(something.join());
  }
}