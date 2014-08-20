import "package:unittest/unittest.dart";

typedef void TestGroup();

class SuiteInfo {
  final String name;
  
  final Map<String, TestGroup> sections;
  
  SuiteInfo(this.name, {this.sections: const {}});
}

void runTests(List<SuiteInfo> modules) {
  for (var module in modules) {
    group(module.name, () {
      for (var name in module.sections.keys) {
        group(name, module.sections[name]);
      }
    });
  }
}