part of alpha.core;

num sum(List<num> numbers) => numbers.reduce((a, b) => a + b);
num average(List<num> numbers) => sum(numbers) / numbers.length;
