import 'dart:io';

import 'package:alfred/alfred.dart';
// import 'package:shelf_hotreload/shelf_hotreload.dart';

import 'shared/constants/constants.dart';
import 'shared/database/connector.dart';
import 'shared/env.dart';
import 'shared/memory/i_memory.dart';
import 'shared/route_mapper/route_mapper.dart';

// start Commando with HotReload
//
// dart --enable-vm-service bin/server.dart
void main() async {
  connector = await Connector.connect();
  await imemory.load(connector!);
  if (connector == null) {
    throw Exception('Invalid Credencials');
  } else {
    // withHotreload(() async => startServer());

    await startServer(
      memory: imemory,
    );
  }
}

Future<HttpServer> startServer({required IMemory memory}) async {
  imemory = memory;
  final app = Alfred(
    onNotFound: (req, res) async {
      await res.redirect(imemory.find('/'), status: 301);
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
