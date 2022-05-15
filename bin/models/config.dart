import 'dart:convert';
import 'package:http/http.dart' as http;

class Config {
  final String notFound;
  final Map<String, dynamic> def;
  final Map<String, dynamic> sections;

  Config({
    required this.notFound,
    required this.def,
    required this.sections,
  });

  static Config of(String rawContent) {
    var jsonContent = json.decode(rawContent);
    return Config(
      notFound: jsonContent['not_found'],
      def: jsonContent['default'],
      sections: jsonContent['sections'],
    );
  }

  static Future<Config?> fromUrl(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Config.of(response.body);
    }
  }

  String parse(List<String> params) {
    if (params.isEmpty || params.length > 3) return notFound;
    if (params.length == 1) {
      return def[params[0]] ?? notFound;
    } else {
      if (sections[params[0]] == null) return notFound;
      if (params.length == 2) {
        return sections[params[0]][params[1]] ?? notFound;
      } else {
        if (sections[params[0]][params[1]] == null) return notFound;
        return sections[params[0]][params[1]][params[2]] ?? notFound;
      }
    }
  }
}
