import 'package:alfred/alfred.dart';

import '../../shared/constants/constants.dart';
import '../../shared/env.dart';
import '../../models/config.dart';

class ShortenService {
  static route(Alfred server) {
    server.get('/*', (req, res) async {
      var params = req.uri.pathSegments;
      await res.redirect(Uri.parse(config!.parse(params)), status: 301);
    });

    server.put('/update/:key', (req, res) async {
      String key = req.params['key'];
      String systemKey = Env.get('AUTH_TOKEN', '');
      if (systemKey.isNotEmpty && (key == systemKey)) {
        String url = Env.get('JSON_URL', '');
        if (url.isNotEmpty) {
          config = await Config.fromUrl(url);
          return {'message': 'Update performed successfully.'};
        }
        return {
          'message': 'Unable to perform update',
          'error': 'Environment variable "JSON_URL" not configured correctly',
        };
      } else {
        return {
          'message': 'Unable to perform update',
          'error': 'Invalid authentication key',
        };
      }
    });
  }
}
