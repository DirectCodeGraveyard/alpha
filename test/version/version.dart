part of alpha.test.version;

void parsing() {
  for (var number in range(1, 20)) {
    test("${number}.0.0 is parsed correctly", () {
      var version = new Version.parse("${number}.0.0");
      expect(version.major, equals(number));
      expect(version.minor, equals(0));
      expect(version.patch, equals(0));
    });
  }
  
  for (var number in range(1, 9)) {
    test("1.0.${number} is parsed correctly", () {
      var version = new Version.parse("1.0.${number}");
      expect(version.major, equals(1));
      expect(version.minor, equals(0));
      expect(version.patch, equals(number));
    });
  }
}
