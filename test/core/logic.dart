part of alpha.test.core;

void logic() {
  test("not", () {
    expect(not(false), isTrue);
    expect(not(true), isFalse);
  });
  
  test("and", () {
    expect(and(true, true), isTrue);
    expect(and(true, false), isFalse);
    expect(and(false, false), isFalse);
  });
  
  test("increment", () {
    expect(increment(-1), equals(0));
    expect(increment(0), equals(1));
    expect(increment(1), equals(2));
    expect(increment(2), equals(3));
  });
  
  test("decrement", () {
    expect(decrement(-1), equals(-2));
    expect(decrement(0), equals(-1));
    expect(decrement(1), equals(0));
    expect(decrement(2), equals(1));
  });
}