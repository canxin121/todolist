// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `CONFIG` is not used by any `pub` functions, thus it is ignored.

Future<void> initConfig({required Config config, dynamic hint}) =>
    RustLib.instance.api.initConfig(config: config, hint: hint);

class Config {
  final String cacheRoot;

  const Config({
    required this.cacheRoot,
  });

  @override
  int get hashCode => cacheRoot.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          runtimeType == other.runtimeType &&
          cacheRoot == other.cacheRoot;
}
