import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:testapp/src/services/http_service.dart';
import 'package:testapp/src/services/logger_service.dart';

/// Service provider class to register all services
class ServiceProvider {
  static final _getIt = GetIt.instance;

  static Future<void> init() async {
    try {
      // logger
      _getIt.registerSingleton(LoggerService());

      // http
      _getIt.registerSingleton(HttpService(HttpClient()));

      await _getIt.allReady();
    } catch (e, st) {
      loggerService.error('services error', e, st);
    }
  }
}

LoggerService get loggerService {
  return ServiceProvider._getIt.get<LoggerService>();
}

HttpService get httpService {
  return ServiceProvider._getIt.get<HttpService>();
}
