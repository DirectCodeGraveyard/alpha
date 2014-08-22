import "package:unittest/unittest.dart";
import "package:unittest/src/utils.dart";

import "dart:io";

typedef void TestGroup();

class SuiteInfo {
  final String name;
  final Map<String, TestGroup> sections;

  SuiteInfo(this.name, {this.sections: const {}});
}

void runTests(List<SuiteInfo> modules) {

  unittestConfiguration = new AlphaTestConfiguration();

  for (var module in modules) {
    group(module.name, () {
      for (var name in module.sections.keys) {
        group(name, module.sections[name]);
      }
    });
  }
}

void runSuite(SuiteInfo module) => runTests([module]);

class AlphaTestConfiguration extends SimpleConfiguration {
  final String GREEN_COLOR = '\u001b[32m';
  final String RED_COLOR = '\u001b[31m';
  final String MAGENTA_COLOR = '\u001b[35m';
  final String NO_COLOR = '\u001b[0m';

  @override
  void onInit() {
    filterStacks = formatStacks = true;
  }

  @override
  String formatResult(TestCase testCase) {
    var buff = new StringBuffer();

    var status = testCase.result;
    
    var color = "";
    
    switch (status) {
      case PASS:
        color = GREEN_COLOR;
        break;
      case FAIL:
        color = RED_COLOR;
        break;
      case ERROR:
        color = MAGENTA_COLOR;
        break;
    }
    
    buff
        ..write(color)
        ..write(status.toUpperCase())
        ..write(NO_COLOR)
        ..write(": ")
        ..write(testCase.description)
        ..writeln();

    if (testCase.message.isNotEmpty) {
      buff.writeln(indent(testCase.message));
    }

    if (testCase.stackTrace != null) {
      buff.writeln(indent(testCase.stackTrace.toString()));
    }

    return buff.toString();
  }

  @override
  void onSummary(int passed, int failed, int errors, List<TestCase> results, String uncaughtError) {
    for (final t in results) {
      print(formatResult(t).trim());
    }

    print('');

    if (passed == 0 && failed == 0 && errors == 0 && uncaughtError == null) {
      print('No tests found.');
    } else if (failed == 0 && errors == 0 && uncaughtError == null) {
      print('All ${passed} tests passed.');
    } else {
      if (uncaughtError != null) {
        print('Top-level uncaught error: ${uncaughtError}');
      }
      print('${passed} PASSED, ${failed} FAILED, ${errors} ERRORS');
    }
  }

  @override
  void onDone(bool success) {
    int status;

    try {
      if (throwOnTestFailures) {
        throw new Exception('Some tests failed.');
      }
      status = 0;
    } catch (ex) {
      status = 1;
    }
    
    exit(status);
  }
}
