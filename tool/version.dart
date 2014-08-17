part of build;

var VERSION_REGEX = new RegExp(r"^(\d+)\.(\d+)\.(\d+)$");

TaskFunction createVersionTask() {
  return (GrinderContext context) {
    var file = new File("pubspec.yaml");
    return new Future(() {
      var content = file.readAsStringSync();
      var pubspec = loadYaml(content);
      var old = pubspec["version"];
      var readme = new File("README.md");

      var next = null;
      
      try {
        next = incrementVersion(old);
      } catch (e) {
        context.fail("${e}");
        return;
      }

      content = content.replaceAll(old, next);
      readme.writeAsStringSync(readme.readAsStringSync().replaceAll(old, next));
      file.writeAsStringSync(content);
      context.log("Updated Version: v${old} => v${next}");
    });
  };
}

String incrementVersion(String old) {
  if (!VERSION_REGEX.hasMatch(old)) {
    throw new Exception("the version in the pubspec is not a valid version");
  }
  var match = VERSION_REGEX.firstMatch(old);
  List<String> split = old.split(".");
  int major = int.parse(match[1]);
  int minor = int.parse(match[2]);
  int bugfix = int.parse(match[3]);
  if (bugfix == 9) {
    bugfix = 0;
    minor++;
  } else {
    bugfix++;
  }
  return "${major}.${minor}.${bugfix}";
}
