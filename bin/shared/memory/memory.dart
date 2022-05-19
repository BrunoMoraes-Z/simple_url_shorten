import '../database/connector.dart';
import 'i_memory.dart';

class Memory implements IMemory {
  final Map<String, dynamic> _memory = {};

  @override
  Future<void> load(Connector connector) async {
    _memory.clear();
    print('Starting Memory Reading');
    var results = await connector.run(
      'SELECT ds_key, ds_value FROM tb_shorten_links',
    );

    for (var row in results) {
      _memory[row.first] = row.last;
    }
    print('Finished reading from memory');
  }

  @override
  Uri find(String key) {
    return Uri.parse(_memory[key] ?? _memory['/']);
  }

  @override
  dynamic dump() {
    return _memory;
  }
}
