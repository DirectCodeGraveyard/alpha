#!/usr/bin/env dart

library build;

import 'dart:async';
import "dart:io";

import "package:grinder/grinder.dart";
import 'package:yaml/yaml.dart';

part 'docgen.dart';
part 'utils.dart';
part 'version.dart';
part 'analyze.dart';
part 'config.dart';

void main(List<String> args) {
  init();

  task("docs", createDocGenTask(".", out_dir: parse_config_value(getvar("docs.output", "out/docs"))));
  
  task("analyze", createAnalyzerTask(getvar("analyzer.files", []).map(parse_config_value)));
  
  task("test", (context) {
    runDartScript(context, getvar("test.file", "test/run.dart"));
  });
  
  task("version", createVersionTask());
  
  task("publish", (context) {
    runSdkBinary(context, "pub", arguments: ["publish", "-f"]);
  }, depends: ["version"]);
  
  task("check", (_) {}, depends: getvar("check.tasks", []).map(parse_config_value).toList());

  startGrinder(args);
}

void task(String name, TaskFunction function, {List<String> depends: const []}) {
  defineTask(name, taskFunction: function, depends: depends);
}