part of alpha.console;

class Clipboard {
  static bool _isSupported;
  
  static bool get isSupported {
    if (_isSupported == null) {
      _determineSupport();
    }
    return _isSupported;
  }
  
  static void _determineSupport() {
    bool supported = false;
    if (Platform.isLinux) {
      if (new File("/usr/bin/xclip").existsSync()) {
        supported = true;
      }
    }
    _isSupported = supported;
  }
  
  static String getClipboard() {
    var result = Process.runSync("/usr/bin/xclip", ["-selection", "clipboard", "-o"]);
    if (result.exitCode != 0) {
      throw new Exception("Failed to get clipboard. Exit Code was not 0");
    }
    return result.stdout.toString();
  }
  
  static void setClipboard(String content) {
    Process.start("/usr/bin/xclip", ["-selection", "clipboard"]).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}