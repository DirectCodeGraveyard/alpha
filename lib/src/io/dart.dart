part of alpha.io;

class DartInformation {
  static String get INFO => Platform.version;
  
  static int get revision =>
      int.parse(fullVersion.split("\.").last);
  
  static Version get version {
    return new Version.parse(fullVersion);
  }
  
  static String get fullVersion {
    var split = INFO.split(" ");
    return split[0];
  }
}