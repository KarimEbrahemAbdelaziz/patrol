import 'package:version/version.dart';

class VersionComparator {
  VersionComparator({
    required List<VersionRange> cliVersionRange,
    required List<VersionRange> packageVersionRange,
  })  : _cliVersionRange = cliVersionRange,
        _cliToPackageMap = Map.fromIterables(
          cliVersionRange,
          packageVersionRange,
        );

  final List<VersionRange> _cliVersionRange;
  final Map<VersionRange, VersionRange> _cliToPackageMap;

  /// Checks if the current CLI version is compatible with the given package version.
  bool isCompatible(Version cliVersion, Version packageVersion) {
    final matchingCliVersionRanges =
        _getMatchingRanges(cliVersion, _cliVersionRange);

    for (final cliVersionRange in matchingCliVersionRanges) {
      final packageVersionRange = _cliToPackageMap[cliVersionRange];
      if (packageVersionRange != null &&
          isInRange(packageVersion, packageVersionRange)) {
        return true;
      }
    }

    return false;
  }

  List<VersionRange> _getMatchingRanges(
    Version version,
    List<VersionRange> versionRangeList,
  ) {
    return [
      for (final versionRange in versionRangeList)
        if (isInRange(version, versionRange)) versionRange,
    ];
  }

  bool isInRange(Version version, VersionRange versionRange) {
    return version >= versionRange.min &&
        (_hasNoUpperBound(versionRange) || version <= versionRange.max);
  }

  bool _hasNoUpperBound(VersionRange versionRange) {
    return versionRange.max == null;
  }
}

class VersionRange {
  VersionRange({
    required this.min,
    this.max,
  });

  final Version min;
  final Version? max;
}
