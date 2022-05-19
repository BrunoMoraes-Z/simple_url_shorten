import '../../../shared/memory/i_memory.dart';

class RouteController {
  final IMemory memory;

  const RouteController({required this.memory});

  Uri redir(List<String> params) {
    var term = params.length == 1 ? params[0] : params.join('/');
    return memory.find(term);
  }
}
