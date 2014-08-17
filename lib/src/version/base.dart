part of alpha.version;

final _equality = const IterableEquality();

final _START_VERSION = new RegExp(
    r'^'                                        // Start at beginning.
    r'(\d+).(\d+).(\d+)'                        // Version number.
    r'(-([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?'    // Pre-release.
    r'(\+([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?'); // Build.

final _COMPLETE_VERSION = new RegExp("${_START_VERSION.pattern}\$");
final _START_COMPARISON = new RegExp(r"^[<>]=?");

class Version implements Comparable<Version>, VersionConstraint {
  static Version get none => new Version(0, 0, 0);

  static int prioritize(Version a, Version b) {
    if (a.isPreRelease && !b.isPreRelease) return -1;
    if (!a.isPreRelease && b.isPreRelease) return 1;

    return a.compareTo(b);
  }
  
  static int antiPrioritize(Version a, Version b) {
    if (a.isPreRelease && !b.isPreRelease) return -1;
    if (!a.isPreRelease && b.isPreRelease) return 1;

    return b.compareTo(a);
  }

  final int major;
  final int minor;
  final int patch;
  final List preRelease;
  final List build;

  final String _text;

  Version._(this.major, this.minor, this.patch, String preRelease, String build,
            this._text)
      : preRelease = preRelease == null ? [] : _splitParts(preRelease),
        build = build == null ? [] : _splitParts(build) {
    if (major < 0) throw new ArgumentError(
        'Major version must be non-negative.');
    if (minor < 0) throw new ArgumentError(
        'Minor version must be non-negative.');
    if (patch < 0) throw new ArgumentError(
        'Patch version must be non-negative.');
  }

  factory Version(int major, int minor, int patch, {String pre, String build}) {
    var text = "$major.$minor.$patch";
    if (pre != null) text += "-$pre";
    if (build != null) text += "+$build";

    return new Version._(major, minor, patch, pre, build, text);
  }

  factory Version.parse(String text) {
    final match = _COMPLETE_VERSION.firstMatch(text);
    if (match == null) {
      throw new FormatException('Could not parse "$text".');
    }

    try {
      int major = int.parse(match[1]);
      int minor = int.parse(match[2]);
      int patch = int.parse(match[3]);

      String preRelease = match[5];
      String build = match[8];

      return new Version._(major, minor, patch, preRelease, build, text);
    } on FormatException catch (ex) {
      throw new FormatException('Could not parse "$text".');
    }
  }

  static Version primary(List<Version> versions) {
    var primary;
    for (var version in versions) {
      if (primary == null || (!version.isPreRelease && primary.isPreRelease) ||
          (version.isPreRelease == primary.isPreRelease && version > primary)) {
        primary = version;
      }
    }
    return primary;
  }

  static List _splitParts(String text) {
    return text.split('.').map((part) {
      try {
        return int.parse(part);
      } on FormatException catch (ex) {
        return part;
      }
    }).toList();
  }

  bool operator ==(other) {
    if (other is! Version) return false;
    return major == other.major && minor == other.minor &&
        patch == other.patch &&
        _equality.equals(preRelease, other.preRelease) &&
        _equality.equals(build, other.build);
  }

  int get hashCode => major ^ minor ^ patch ^ _equality.hash(preRelease) ^
      _equality.hash(build);

  bool operator <(Version other) => compareTo(other) < 0;
  bool operator >(Version other) => compareTo(other) > 0;
  bool operator <=(Version other) => compareTo(other) <= 0;
  bool operator >=(Version other) => compareTo(other) >= 0;

  bool get isAny => false;
  bool get isEmpty => false;

  bool get isPreRelease => preRelease.isNotEmpty;

  Version get nextMajor {
    if (isPreRelease && minor == 0 && patch == 0) {
      return new Version(major, minor, patch);
    }

    return new Version(major + 1, 0, 0);
  }

  Version get nextMinor {
    if (isPreRelease && patch == 0) {
      return new Version(major, minor, patch);
    }

    return new Version(major, minor + 1, 0);
  }

  Version get nextPatch {
    if (isPreRelease) {
      return new Version(major, minor, patch);
    }

    return new Version(major, minor, patch + 1);
  }

  bool allows(Version other) => this == other;

  VersionConstraint intersect(VersionConstraint other) {
    if (other.isEmpty) return other;
    
    if (other is VersionRange) return other.intersect(this);

    if (other is Version) {
      return this == other ? this : VersionConstraint.empty;
    }

    throw new ArgumentError(
        'Unknown VersionConstraint type $other.');
  }

  int compareTo(Version other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);

    if (!isPreRelease && other.isPreRelease) return 1;
    if (!other.isPreRelease && isPreRelease) return -1;

    var comparison = _compareLists(preRelease, other.preRelease);
    if (comparison != 0) return comparison;

    if (build.isEmpty && other.build.isNotEmpty) return -1;
    if (other.build.isEmpty && build.isNotEmpty) return 1;
    return _compareLists(build, other.build);
  }

  String toString() => _text;

  int _compareLists(List a, List b) {
    for (var i = 0; i < (a.length > b.length ? a.length : b.length); i++) {
      var aPart = (i < a.length) ? a[i] : null;
      var bPart = (i < b.length) ? b[i] : null;

      if (aPart == bPart) continue;

      if (aPart == null) return -1;
      if (bPart == null) return 1;

      if (aPart is num) {
        if (bPart is num) {
          return aPart.compareTo(bPart);
        } else {
          return -1;
        }
      } else {
        if (bPart is num) {
          return 1;
        } else {
          return aPart.compareTo(bPart);
        }
      }
    }
    return 0;
  }
}