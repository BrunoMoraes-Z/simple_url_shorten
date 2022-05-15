import 'dart:convert';

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../bin/server.dart';
import 'package:http/http.dart' as http;

void main() {
  setUpAll(() async {
    await startServer(
      raw: json.encode({
        "not_found": "https://www.google.com/",
        "default": {"discord": "https://discordapp.com/"},
        "sections": {
          "videos": {
            "music": "https://www.youtube.com/watch?v=Xsr0i91VH-0",
            "clicp": "https://www.youtube.com/watch?v=TO-_3tck2tg"
          },
          "clips": {
            "musics": {
              "track1": "https://www.youtube.com/watch?v=TO-_3tck2tg",
            }
          }
        }
      }),
    );
  });

  Future<http.Response> get(String path) async {
    return await http.get(
      Uri.parse('http://localhost:8080$path'),
    );
  }

  test('[01] -» Key Not Found', () async {
    var response = await get('/test');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.google.com'));
  });

  test('[02] -» Key Found', () async {
    var response = await get('/discord');
    expect(response.statusCode, 200);
    expect(
      response.headers['content-security-policy'],
      contains('discord.com'),
    );
    expect(response.body, contains('API_ENDPOINT: \'//discord.com/api\''));
  });

  test('[03] -» Section1 Not Found', () async {
    var response = await get('/videos_/music');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.google.com'));
  });

  test('[04] -» Section1 Found And Key Not Found', () async {
    var response = await get('/videos/music_');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.google.com'));
  });

  test('[05] -» Section1 Found And Key Found', () async {
    var response = await get('/videos/music');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.youtube.com'));
  });

  test('[06] -» Section2 Not Found', () async {
    var response = await get('/clips/musics_/track1');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.google.com'));
  });

  test('[07] -» Section2 Found And Key Not Found', () async {
    var response = await get('/clips/musics/track1_');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.google.com'));
  });

  test('[08] -» Section2 Found And Key Found', () async {
    var response = await get('/clips/musics/track1');
    expect(response.statusCode, 200);
    expect(response.headers['set-cookie'], contains('.youtube.com'));
  });
}
