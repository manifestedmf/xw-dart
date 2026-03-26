/// The package for the function [printf] & [printg] & [scanf].
///
/// Added in `2.8`.
library xw.io;

import 'src/io/output.dart' show printf, printg, scanf;
import 'dart:io' as io show exit;

export 'src/io/output.dart';
export 'src/io/input.dart';
//export 'src/io/file.dart';

/// Exits the program with [code].
///
/// Added in `2.8`.
Never exit(int code) => io.exit(code);