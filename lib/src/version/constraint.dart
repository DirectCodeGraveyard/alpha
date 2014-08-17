part of alpha.version;

abstract class VersionConstraint {
  static VersionConstraint any = new VersionRange();

  static VersionConstraint empty = const _EmptyVersion();

  static Future<VersionConstraint> create(String input) {
    return new Future(() {
      return new VersionConstraint.parse(input);
    });
  }
  
  factory VersionConstraint.parse(String text) {
    if (text.trim() == "any") return new VersionRange();

    var originalText = text;
    var constraints = <VersionConstraint>[];

    void skipWhitespace() {
      text = text.trim();
    }

    Version matchVersion() {
      var version = _START_VERSION.firstMatch(text);
      if (version == null) return null;

      text = text.substring(version.end);
      return new Version.parse(version[0]);
    }

    VersionConstraint matchComparison() {
      var comparison = _START_COMPARISON.firstMatch(text);
      if (comparison == null) return null;

      var op = comparison[0];
      text = text.substring(comparison.end);
      skipWhitespace();

      var version = matchVersion();
      if (version == null) {
        throw new FormatException('Expected version number after "$op" in '
            '"$originalText", got "$text".');
      }

      switch (op) {
        case '<=':
          return new VersionRange(max: version, includeMax: true);
        case '<':
          return new VersionRange(max: version, includeMax: false);
        case '>=':
          return new VersionRange(min: version, includeMin: true);
        case '>':
          return new VersionRange(min: version, includeMin: false);
      }
      throw "Unreachable.";
    }

    while (true) {
      skipWhitespace();
      if (text.isEmpty) break;

      var version = matchVersion();
      if (version != null) {
        constraints.add(version);
        continue;
      }

      var comparison = matchComparison();
      if (comparison != null) {
        constraints.add(comparison);
        continue;
      }

      throw new FormatException('Could not parse version "$originalText". '
          'Unknown text at "$text".');
    }

    if (constraints.isEmpty) {
      throw new FormatException('Cannot parse an empty string.');
    }

    return new VersionConstraint.intersection(constraints);
  }
  
  factory VersionConstraint.intersection(
      Iterable<VersionConstraint> constraints) {
    var constraint = new VersionRange();
    for (var other in constraints) {
      constraint = constraint.intersect(other);
    }
    return constraint;
  }

  bool get isEmpty;

  bool get isAny;

  bool allows(Version version);

  VersionConstraint intersect(VersionConstraint other);
}

class VersionRange implements VersionConstraint {
  final Version min;
  final Version max;
  final bool includeMin;
  final bool includeMax;

  VersionRange({this.min, this.max,
      this.includeMin: false, this.includeMax: false}) {
    if (min != null && max != null && min > max) {
      throw new ArgumentError(
          'Minimum version ("$min") must be less than maximum ("$max").');
    }
  }

  bool operator ==(other) {
    if (other is! VersionRange) return false;

    return min == other.min &&
           max == other.max &&
           includeMin == other.includeMin &&
           includeMax == other.includeMax;
  }

  bool get isEmpty => false;

  bool get isAny => min == null && max == null;

  /// Tests if [other] matches falls within this version range.
  bool allows(Version other) {
    if (min != null) {
      if (other < min) return false;
      if (!includeMin && other == min) return false;
    }

    if (max != null) {
      if (other > max) return false;
      if (!includeMax && other == max) return false;

      if (!includeMax &&
          !max.isPreRelease && other.isPreRelease &&
          other.major == max.major && other.minor == max.minor &&
          other.patch == max.patch) {
        return false;
      }
    }

    return true;
  }

  VersionConstraint intersect(VersionConstraint other) {
    if (other.isEmpty) return other;

    if (other is Version) {
      return allows(other) ? other : VersionConstraint.empty;
    }

    if (other is VersionRange) {
      // Intersect the two ranges.
      var intersectMin = min;
      var intersectIncludeMin = includeMin;
      var intersectMax = max;
      var intersectIncludeMax = includeMax;

      if (other.min == null) {
        // Do nothing.
      } else if (intersectMin == null || intersectMin < other.min) {
        intersectMin = other.min;
        intersectIncludeMin = other.includeMin;
      } else if (intersectMin == other.min && !other.includeMin) {
        // The edges are the same, but one is exclusive, make it exclusive.
        intersectIncludeMin = false;
      }

      if (other.max == null) {
        // Do nothing.
      } else if (intersectMax == null || intersectMax > other.max) {
        intersectMax = other.max;
        intersectIncludeMax = other.includeMax;
      } else if (intersectMax == other.max && !other.includeMax) {
        intersectIncludeMax = false;
      }

      if (intersectMin == null && intersectMax == null) {
        return new VersionRange();
      }

      if (intersectMin == intersectMax) {
        // If both ends are inclusive, allow that version.
        if (intersectIncludeMin && intersectIncludeMax) return intersectMin;

        // Otherwise, no versions.
        return VersionConstraint.empty;
      }

      if (intersectMin != null && intersectMax != null &&
          intersectMin > intersectMax) {
        return VersionConstraint.empty;
      }

      return new VersionRange(min: intersectMin, max: intersectMax,
          includeMin: intersectIncludeMin, includeMax: intersectIncludeMax);
    }

    throw new ArgumentError('Unknown VersionConstraint type $other.');
  }

  @override
  String toString() {
    var buffer = new StringBuffer();

    if (min != null) {
      buffer.write(includeMin ? '>=' : '>');
      buffer.write(min);
    }

    if (max != null) {
      if (min != null) buffer.write(' ');
      buffer.write(includeMax ? '<=' : '<');
      buffer.write(max);
    }

    if (min == null && max == null) buffer.write('any');
    return buffer.toString();
  }
}

class _EmptyVersion implements VersionConstraint {
  const _EmptyVersion();

  bool get isEmpty => true;
  bool get isAny => false;
  bool allows(Version other) => false;
  VersionConstraint intersect(VersionConstraint other) => this;
  
  @override
  String toString() => '<empty>';
}