part of build;

TaskFunction createDocGenTask(String path, {compile: false, Iterable<String> excludes: null, include_sdk: true, include_deps: false, out_dir: "docs", verbose: false}) {
  return (GrinderContext context) {
    var args = [];

    if (verbose) {
      args.add("--verbose");
    }

    if (excludes != null) {
      for (String exclude in excludes) {
        args.add("--exclude-lib=${exclude}");
      }
    }

    if (compile) {
      args.add("--compile");
    }

    args.add(_flag("include-sdk", include_sdk));

    args.add(_flag("include-dependent-packages", include_deps));

    args.add("--out=${out_dir}");

    args.add(path);

    return Process.start("docgen", args).then((process) {
      return inheritIO(process);
    }).then((code) {
      if (code != 0) {
        context.fail("docgen exited with the status code ${code}");
      }
    });
  };
}

String _flag(String it, bool flag) => flag ? it : "--no-" + it;
