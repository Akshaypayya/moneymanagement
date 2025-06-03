import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class InternetService {
  static const String _testUrl = 'google.com';
  static const int _timeoutDuration = 10;

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(_testUrl).timeout(
        const Duration(seconds: _timeoutDuration),
      );

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('INTERNET SERVICE: Connection available');
        return true;
      }

      debugPrint('INTERNET SERVICE: No connection - empty result');
      return false;
    } catch (e) {
      debugPrint('INTERNET SERVICE: No connection - Error: $e');
      return false;
    }
  }

  static Future<bool> hasInternetConnectionHttp() async {
    try {
      final client = HttpClient();
      final request =
          await client.getUrl(Uri.parse('https://www.google.com')).timeout(
                const Duration(seconds: _timeoutDuration),
              );
      final response = await request.close().timeout(
            const Duration(seconds: _timeoutDuration),
          );
      client.close();

      final hasConnection = response.statusCode == 200;
      debugPrint(
          'INTERNET SERVICE HTTP: Connection ${hasConnection ? 'available' : 'unavailable'}');
      return hasConnection;
    } catch (e) {
      debugPrint('INTERNET SERVICE HTTP: No connection - Error: $e');
      return false;
    }
  }

  static Future<bool> pingTest({String host = 'google.com'}) async {
    try {
      final result = await Process.run('ping', ['-c', '1', host]).timeout(
        const Duration(seconds: _timeoutDuration),
      );

      final hasConnection = result.exitCode == 0;
      debugPrint(
          'INTERNET SERVICE PING: Connection ${hasConnection ? 'available' : 'unavailable'}');
      return hasConnection;
    } catch (e) {
      debugPrint('INTERNET SERVICE PING: Error - $e');
      return false;
    }
  }
}
