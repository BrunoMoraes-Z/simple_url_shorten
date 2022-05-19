import '../database/connector.dart';

abstract class IMemory {
  Future<void> load(Connector connector);

  Uri find(String key);
}
