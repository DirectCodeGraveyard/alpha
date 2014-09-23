import "package:alpha/data.dart";

void main() {
  {
    var words = [
      "Hello",
      "World",
      "and",
      "all",
      "those",
      "who",
      "inhabit",
      "it."
    ];
    
    var sorted = new List.from(words)..sort(Sorters.LARGEST_STRING_LENGTH);
    print("Original: ${words.join(" ")}");
    print("Sorted: ${sorted.join(" ")}");
  }
  
  {
    var distributor = new Distributor<String>();
    
    distributor.add((value) => print("Distributor: ${value}"));
    
    distributor.emit("Hello World");
  }

}