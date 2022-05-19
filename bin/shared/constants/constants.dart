import 'dart:io';

import '../database/connector.dart';
import '../memory/i_memory.dart';
import '../memory/memory.dart';

String baseDir = Directory.fromUri(Platform.script).parent.parent.path;
Connector? connector;
IMemory imemory = Memory();
