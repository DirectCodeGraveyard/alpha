import "package:unittest/unittest.dart";

import "dart:async";
import "dart:io";

typedef void TestGroup();

class SuiteInfo {
  final String name;

  final Map<String, TestGroup> sections;

  SuiteInfo(this.name, {this.sections: const {}});
}

void runTests(List<SuiteInfo> modules) {

  unittestConfiguration = new AlphaTestConfiguration();

  void printLine(Zone self, ZoneDelegate parent, Zone zone, String line) {
    if (line.startsWith("unittest-")) return;
    stdout.write(line);
  }

  runZoned(() {
    for (var module in modules) {
      group(module.name, () {
        for (var name in module.sections.keys) {
          group(name, module.sections[name]);
        }
      });
    }
  }, zoneSpecification: new ZoneSpecification(print: printLine));
}

void runSuite(SuiteInfo module) => runTests([module]);


class AlphaTestConfiguration extends SimpleConfiguration {
  final String GREEN_COLOR = '\u001b[32m';
  final String RED_COLOR = '\u001b[31m';
  final String MAGENTA_COLOR = '\u001b[35m';
  final String NO_COLOR = '\u001b[0m';
  
  @override
  void onInit() {
    super.onInit();
    filterStacks = formatStacks = true;
  }
  
  @override
  String formatResult(TestCase testCase) {
    var result = super.formatResult(testCase);
    if (testCase.result == PASS) {
      return "${GREEN_COLOR}${result}${NO_COLOR}";
    } else if (testCase.result == FAIL) {
      return "${RED_COLOR}${result}${NO_COLOR}";
    } else if (testCase.result == ERROR) {
      return "${MAGENTA_COLOR}${result}${NO_COLOR}";
    }
    return result;
  }
  
  @override
  void onDone(bool success) {
    int status;
    
    try {
      super.onDone(success);
      status = 0;
    } catch (ex) {
      status = 1;
    }
    
    print("\n");
    
    exit(status);
  }
}
