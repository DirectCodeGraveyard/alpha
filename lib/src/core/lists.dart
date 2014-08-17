part of alpha.core;

List<dynamic> many(List<dynamic> input, List<int> indexes) {
  var out = [];
  for (var index in indexes) {
    out.add(input[index]);
  }
  return out;
}

List<dynamic> notWhere(List<dynamic> input, bool filter(dynamic it)) =>
    input.where((it) => !filter(it)).toList();

void addMultiple(List<dynamic> input, dynamic object, int times) {
  for (int i = 1; i <= times; i++) {
    input.add(object);
  }
}
