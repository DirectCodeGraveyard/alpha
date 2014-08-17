part of alpha.io;

typedef void DirectoryVisitor(FileSystemEntity entity);

void visitDirectory(Directory directory, DirectoryVisitor visitor) {
  var completer = new Completer();
  directory.list(recursive: true).listen(visitor).onDone(completer.complete);
  return completer.future;
}

dynamic readJSON(File file) =>
    JSON.decode(file.readAsStringSync());

void writeJSON(File file, data, {bool pretty: false, String indent: "  "}) =>
    file.writeAsStringSync((pretty ? new JsonEncoder.withIndent(indent) : new JsonEncoder()).convert(data));

Directory mkdir(String path, {bool recursive: false}) {
  var dir = new Directory(path);
  dir.createSync(recursive: recursive);
  return dir;
}

void cd(String path) {
  Directory.current = new Directory(path);
}

File file(String path) =>
    new File(path);

Directory directory(String path) =>
    new Directory(path);

void write(String path, String data) =>
    file(path).writeAsStringSync(data);

void append(String path, String data) =>
    file(path).writeAsStringSync(data, mode: APPEND);

List<FileSystemEntity> ls(String path, {bool recursive: false}) =>
    directory(path)
      .listSync(recursive: recursive);
