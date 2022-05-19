import 'package:alfred/alfred.dart';

import '../../shared/constants/constants.dart';
import '../../shared/env.dart';
import 'controller/route_controller.dart';

class ShortenService {
  static final RouteController _controller = RouteController(
    memory: imemory,
  );

  static route(Alfred server) {
    server.get('/*', (req, res) async {
      var params = req.uri.pathSegments;
      await res.redirect(_controller.redir(params), status: 301);
    });

    server.put('/update/:key', (req, res) async {
      String key = req.params['key'];
      String systemKey = Env.get('AUTH_TOKEN', '');
      if (systemKey.isNotEmpty && (key == systemKey)) {
        await imemory.load(connector!);
        return {'message': 'Update performed successfully.'};
      } else {
        return {
          'message': 'Unable to perform update',
          'error': 'Invalid authentication key',
        };
      }
    });
  }
}
