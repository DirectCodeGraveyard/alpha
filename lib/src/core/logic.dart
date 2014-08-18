part of alpha.core;

bool and(bool a, bool b) =>
    a && b;

bool not(bool it) =>
    it == false;

bool or(bool a, bool b) =>
    a || b;

bool xor(bool a, bool b) =>
    (a == true) && (b == false) || (a == false) && (b == true);

bool nand(bool a, bool b) =>
    a != b;

bool nor(bool a, bool b) =>
    a == false && b == false;

bool xnor(bool a, bool b) =>
    a == b;

int increment(int i) =>
    i + 1;

int decrement(int i) =>
    i - 1;

num add(num a, num b) =>
    a + b;

num subtract(num a, num b) =>
    a - b;

num multiply(num a, num b) =>
    a * b;

num divide(num a, num b) =>
    a / b;
