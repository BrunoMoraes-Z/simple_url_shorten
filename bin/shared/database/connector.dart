import 'package:postgres/postgres.dart';

import '../env.dart';

class Connector {
  final PostgreSQLConnection connection;

  const Connector({required this.connection});

  Future<PostgreSQLResult> run(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    return await connection.query(query, substitutionValues: params);
  }

  static Future<Connector?> connect() async {
    String database = Env.get('PG_DATABASE', '');
    int port = int.parse(Env.get('PG_PORT', 0));
    String username = Env.get('PG_USERNAME', '');
    String password = Env.get('PG_PASSWORD', '');
    String host = Env.get('PG_HOST', '');

    if (database.isEmpty ||
        port == 0 ||
        username.isEmpty ||
        password.isEmpty ||
        host.isEmpty) {
      print('Invalid Credentials');
      return null;
    } else {
      print('Starting Db Connection...');
      var connection = PostgreSQLConnection(
        host,
        port,
        database,
        username: username,
        password: password,
      );
      await connection.open();
      print('Finished the connection process with the bank');

      return Connector(
        connection: connection,
      );
    }
  }
}
