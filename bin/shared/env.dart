import 'dart:io';

class Env {
  static dynamic get(String key, dynamic defaultValue) =>
      Platform.environment[key] ?? defaultValue;
}
