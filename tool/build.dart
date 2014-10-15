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
    runProcess(context, "pub", arguments: ["publish", "-f"]);
  },["version"]);
  
  task("check", (_) {}, getvar("check.tasks", []).map(parse_config_value).toList());

  startGrinder(args);
}
