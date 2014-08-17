part of alpha.core;

/**
 * Creates a list of integers from [start] to [end].
 */
List<int> range(int start, int end) {
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
