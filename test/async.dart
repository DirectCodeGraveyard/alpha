library alpha.test.async;

import "package:alpha/async.dart";
import "package:unittest/unittest.dart";

import "helper.dart";

part "async/helpers.dart";

final SuiteInfo INFO = new SuiteInfo("core", sections: {
  "helpers": helpers
});

void main() => runSuite(INFO);