part of alpha.data;

List<dynamic> takeWhere(List<dynamic> input, int count, bool filter(dynamic it)) {
  return input.where(filter).take(count);
}
