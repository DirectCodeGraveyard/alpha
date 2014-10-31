part of alpha.core;

class MathHelpers {
  static num sum(List<num> numbers) => numbers.reduce((a, b) => a + b);
  static num average(List<num> numbers) => sum(numbers) / numbers.length;
  static List<int> range(int start, int end) {
    var range = [];
    
    var minus = false;
    
    if (end < start) {
      minus = true;
    }
    
    for (int i = start; i <= end; minus ? i-- : i++) {
      range.add(i);
    }
    return range;
  }
}
