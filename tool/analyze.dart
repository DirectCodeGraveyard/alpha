part of build;

TaskFunction createAnalyzerTask(Iterable<String> files, [Iterable<String> extra_args]) {
  return (GrinderContext context) {
    var args = [];
    args.addAll(files);
    if (extra_args != null) {
      args.addAll(extra_args);
    }
    
    runSdkBinary(context, "dartanalyzer", arguments: args);
  };
}
