part of alpha.test.core;

void lists() {
  test("many", () {
    var result = many([ 1, 2, 3, 4 ], [0, 1, 3]);
    expect(result.length, equals(3));
    expect(result[0], equals(1));
    expect(result[1], equals(2));
    expect(result[2], equals(4));
  });
  
  test("not where", () {
    var input = [ 1, 3, 4, 5, 7, 8 ];
    var result = notWhere(input, (it) => it < 8);
    expect(result.length, equals(1));
    expect(result[0], equals(8));
  });
}