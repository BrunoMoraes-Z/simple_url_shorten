import '../../bin/shared/database/connector.dart';
import '../../bin/shared/memory/i_memory.dart';

class MemoryMock implements IMemory {
  @override
  Future<void> load(Connector connector) {
    throw UnimplementedError();
  }

  @override
  Uri find(String key) {
    var uri = Uri.parse(_mem(key) ?? _mem('/')!);
    print('a');
    return uri;
  }

  String? _mem(String key) {
    String? raw;
    switch (key.toLowerCase()) {
      case '/':
        raw = 'https://www.google.com/';
        break;
      case 'discord':
        raw = 'https://discordapp.com/';
        break;
      case 'videos/music':
        raw = 'https://www.youtube.com/watch?v=Xsr0i91VH-0';
        break;
      case 'clips/musics/track1':
        raw = 'https://www.youtube.com/watch?v=TO-_3tck2tg';
        break;
      default:
        raw = null;
    }
    return raw;
  }
}
