library alpha.test.version;

import "package:alpha/core.dart";
import "package:alpha/version.dart";
import "package:unittest/unittest.dart";

import "helper.dart";

part 'version/version.dart';

final SuiteInfo INFO = new SuiteInfo("version", sections: {
  "parsing": parsing
});

void main() => runSuite(INFO);