import "helper.dart";

import "core.dart" as Core;
import "async.dart" as Async;
import "version.dart" as Version;

void main() =>
    runTests([ Core.INFO, Async.INFO, Version.INFO ]);