library alpha.test.core;

import "package:alpha/core.dart";
import "package:unittest/unittest.dart";

import "helper.dart";

part "core/logic.dart";
part "core/lists.dart";

final SuiteInfo INFO = new SuiteInfo("core", sections: {
  "logic": logic,
  "lists": lists
});

void main() => runSuite(INFO);