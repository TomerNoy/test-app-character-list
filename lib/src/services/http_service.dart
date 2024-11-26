import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:testapp/src/models/result.dart';
import 'package:testapp/src/services/services.dart';

enum HttpMethod { get }

/// HttpService class to handle HTTP requests
class HttpService {
  HttpService(this._client);

  final HttpClient _client;

  /// List of HTTP status codes that are retriable
  final _codesForRetry = [
    HttpStatus.serviceUnavailable,
    HttpStatus.badGateway,
    HttpStatus.internalServerError,
    HttpStatus.gatewayTimeout,
    HttpStatus.tooManyRequests,
    HttpStatus.requestTimeout,
  ];

  /// Global call method to make HTTP requests
  /// (for now only GET requests needed)
  Future<Result<Map<String, dynamic>>> call({
    required HttpMethod method,
    required String path,
    int retries = 5,
  }) async {
    for (int currentRetry = 0; currentRetry <= retries; currentRetry++) {
      try {
        final uri = Uri.parse(path);
        loggerService.debug('Starting HTTP call to $path');
        final request = await switch (method) {
          HttpMethod.get => _client.getUrl(uri),
        };

        request.headers.contentType = ContentType.json;

        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        final code = response.statusCode;

        loggerService.debug(
          'HTTP response: $path, code: $code, body: $responseBody',
        );

        // Success
        if (code == HttpStatus.ok) {
          final responseData = _safeDecodeJson(responseBody);
          if (responseData is Map<String, dynamic>) {
            return Result(
              data: {
                'results': responseData['results'] ?? [],
                'info': responseData['info'] ?? {},
              },
            );
          }
          return Result(error: 'Malformed JSON structure in success response');
        }

        // Non-retriable HTTP error
        if (!_codesForRetry.contains(code)) {
          return Result(
            error: _handleNonRetriableError(code, responseBody, path),
          );
        }

        // Log retriable error
        loggerService.warning(
          'Retriable error for $path: code $code, body: $responseBody',
        );
      } catch (e, st) {
        if (e is SocketException) {
          loggerService.warning('SocketException: Retrying connection');
        } else {
          loggerService.error('http call error to $path', e, st);
          return Result(error: '$e');
        }
      }

      // Exponential backoff with jitter for both HTTP and Socket retries
      await _applyExponentialBackoff(currentRetry);
    }

    // Max retries reached
    loggerService.error(
      'http error: max retries of $retries reached for $path',
    );
    return Result(error: 'http error after $retries attempts');
  }

  /// Safely decode JSON
  dynamic _safeDecodeJson(String responseBody) {
    try {
      return json.decode(responseBody);
    } catch (e) {
      loggerService.error('Failed to parse JSON: $responseBody');
      return null;
    }
  }

  /// Handle non-retriable errors
  String _handleNonRetriableError(int code, String responseBody, String path) {
    loggerService.error('Non-retriable error: $code for $path');
    final responseData = _safeDecodeJson(responseBody);
    return responseData is Map<String, dynamic>
        ? responseData['error'] ?? 'Unknown error'
        : 'Unknown error';
  }

  /// Apply exponential backoff with jitter (a bit over engineered for this app)
  Future<void> _applyExponentialBackoff(int retryCount) async {
    final delay = (pow(2, retryCount) * 500).toInt() + Random().nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));
    loggerService.debug('Retrying after $delay ms (retry $retryCount)');
  }
}
