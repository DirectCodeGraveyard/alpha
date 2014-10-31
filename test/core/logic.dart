part of alpha.test.core;

void logic() {
  test("not", () {
    expect(Logics.not(false), isTrue);
    expect(Logics.not(true), isFalse);
  });
  
  test("and", () {
    expect(Logics.and(true, true), isTrue);
    expect(Logics.and(true, false), isFalse);
    expect(Logics.and(false, false), isFalse);
  });
  
  test("increment", () {
    expect(Logics.increment(-1), equals(0));
    expect(Logics.increment(0), equals(1));
    expect(Logics.increment(1), equals(2));
    expect(Logics.increment(2), equals(3));
  });
  
  test("decrement", () {
    expect(Logics.decrement(-1), equals(-2));
    expect(Logics.decrement(0), equals(-1));
    expect(Logics.decrement(1), equals(0));
    expect(Logics.decrement(2), equals(1));
  });
}