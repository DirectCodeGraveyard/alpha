part of alpha.test.version;

var parsingConfig = {
  "x.0.0 range": range(1, 20),
  "1.x.0 range": range(1, 9),
  "1.0.x range": range(1, 9),
  "generic version": "2.0.0"
};

void parsing() {

  test("x.0.0 is parsed correctly", () {
    for (var number in parsingConfig["x.0.0 range"]) {
      var version = new Version.parse("${number}.0.0");
      expect(version.major, equals(number));
      expect(version.minor, equals(0));
      expect(version.patch, equals(0));
    }
  });

  test("1.x.0 is parsed correctly", () {
    for (var number in parsingConfig["1.x.0 range"]) {
      var version = new Version.parse("1.${number}.0");
      expect(version.major, equals(1));
      expect(version.minor, equals(number));
      expect(version.patch, equals(0));
    }
  });

  test("1.0.x is parsed correctly", () {
    for (var number in parsingConfig["1.0.x range"]) {
      var version = new Version.parse("1.0.${number}");
      expect(version.major, equals(1));
      expect(version.minor, equals(0));
      expect(version.patch, equals(number));
    }
  });

  test("build metadata is parsed correctly", () {
    var version = new Version.parse("${parsingConfig["generic version"]}+1");
    expect(version.build.length, equals(1));
    expect(version.build[0], equals(1));
  });

  test("pre-releases are parsed correctly", () {
    var version = new Version.parse("${parsingConfig["generic version"]}-dev");
    expect(version.isPreRelease, isTrue);
    expect(version.preRelease.length, equals(1));
    expect(version.preRelease[0], equals("dev"));
  });
}
