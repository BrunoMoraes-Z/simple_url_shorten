import 'dart:io';

import '../../models/config.dart';

String baseDir = Directory.fromUri(Platform.script).parent.parent.path;
Config? config;
