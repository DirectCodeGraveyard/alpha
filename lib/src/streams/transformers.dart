part of alpha.streams;

class StringTrimmer implements StreamTransformer<String, String> {  
  @override
  Stream<String> bind(Stream<String> stream) =>
      stream.map((value) => value.trim());
}

class StringSplitter implements StreamTransformer<String, List<String>> {
  final Pattern by;
  
  StringSplitter({this.by: " "});
  
  @override
  Stream<List<String>> bind(Stream<String> stream) =>
      stream.map((it) => it.split(by));
}

class StringJoiner implements StreamTransformer<List<String>, String> {
  final String by;
  
  StringJoiner({this.by: " "});
  
  @override
  Stream<String> bind(Stream<List<String>> stream) =>
      stream.map((it) => it.join(by));
}

class SkipEmptyStrings implements StreamTransformer<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) =>
      stream.where((it) => it.isNotEmpty);
}

class SkipNulls<T> implements StreamTransformer<T, T> {
  @override
  Stream<T> bind(Stream<T> stream) => stream.where((it) => it != null);
}

class StringsMatching implements StreamTransformer<String, String> {
  final RegExp expression;
  
  StringsMatching(this.expression);

  @override
  Stream<String> bind(Stream<String> stream) =>
      stream.where((it) => expression.hasMatch(it));
}