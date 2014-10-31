part of alpha.core;

class Logics {
  static bool and(bool a, bool b) =>
      a && b;

  static bool not(bool it) =>
      it == false;

  static bool or(bool a, bool b) =>
      a || b;

  static bool xor(bool a, bool b) =>
      (a == true) && (b == false) || (a == false) && (b == true);

  static bool nand(bool a, bool b) =>
      a != b;

  static bool nor(bool a, bool b) =>
      a == false && b == false;

  static bool xnor(bool a, bool b) =>
      a == b;

  static int increment(int i) =>
      i + 1;

  static int decrement(int i) =>
      i - 1;

  static num add(num a, num b) =>
      a + b;

  static num subtract(num a, num b) =>
      a - b;

  static num multiply(num a, num b) =>
      a * b;

  static num divide(num a, num b) =>
      a / b;
}
