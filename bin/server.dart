import 'dart:io';

import 'package:alfred/alfred.dart';
// import 'package:shelf_hotreload/shelf_hotreload.dart';

import 'models/config.dart';
import 'shared/constants/constants.dart';
import 'shared/env.dart';
import 'shared/route_mapper/route_mapper.dart';

// start Commando with HotReload
//
// dart --enable-vm-service bin/server.dart
void main() async {
  // withHotreload(() async => startServer());
  await startServer();
}

Future<HttpServer> startServer({String raw = ''}) async {
  String url = Env.get('JSON_URL', '');

  if (url.isNotEmpty) {
    config = await Config.fromUrl(url);
  } else {
    config = Config.of(raw);
  }

  final app = Alfred(
    onNotFound: (req, res) async {
      await res.redirect(Uri.parse(config!.notFound), status: 301);
    },
  );

  // Disable CORS
  app.all('*', cors());

  // Log all Requests
  app.printRoutes();

  // Map all Routes
  routeMapper(app);

  // Create a Server
  var server = await app.listen(
    int.parse(Env.get('PORT', '8080')),
    InternetAddress.anyIPv4,
  );

  server.autoCompress = true;

  print('Listen at http://${server.address.host}:${server.port} 🚀');
  return server;
}
