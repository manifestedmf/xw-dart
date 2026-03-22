/// The package for the function [printf] & [printg] & [scanf].
///
/// Added in `2.8`.
library xw.io;

import 'src/output.dart' show printf, printg, scanf;
import 'dart:io' as io show exit;

export 'src/output.dart';
export 'src/input.dart';

/// Exits the program with [code].
///
/// Added in `2.8`.
Never exit(int code) => io.exit(code);