import 'dart:convert';
import 'dart:io';

import 'package:my_app_backend/calculator_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final port = int.tryParse(
        Platform.environment['PORT'] ?? (args.isNotEmpty ? args.first : ''),
      ) ??
      8080;

  final router = Router();
  final calculatorService = CalculatorService();

  router.get('/api/health', (Request request) {
    return _jsonResponse({
      'status': 'ok',
      'message': 'Backend is running',
    });
  });

  router.post('/api/calculate', (Request request) async {
    try {
      final rawBody = await request.readAsString();
      final body = jsonDecode(rawBody);

      if (body is! Map<String, dynamic>) {
        return _jsonResponse(
          {'error': 'Body must be a JSON object.'},
          statusCode: 400,
        );
      }

      final num1 = (body['num1'] as num?)?.toDouble();
      final num2 = (body['num2'] as num?)?.toDouble();
      final operation = body['operation'] as String?;

      if (num1 == null || num2 == null || operation == null) {
        return _jsonResponse(
          {
            'error':
                'Missing required fields: num1 (number), num2 (number), operation (string).',
          },
          statusCode: 400,
        );
      }

      final result = calculatorService.calculate(
        num1: num1,
        num2: num2,
        operation: operation,
      );

      return _jsonResponse({
        'num1': num1,
        'num2': num2,
        'operation': operation,
        'result': result,
      });
    } on FormatException {
      return _jsonResponse(
        {'error': 'Invalid JSON format.'},
        statusCode: 400,
      );
    } on ArgumentError catch (error) {
      return _jsonResponse(
        {'error': error.message.toString()},
        statusCode: 400,
      );
    } catch (_) {
      return _jsonResponse(
        {'error': 'Internal server error.'},
        statusCode: 500,
      );
    }
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    port,
  );

  stdout.writeln('Server running on http://${server.address.host}:${server.port}');
}

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: _corsHeaders,
        );
      }

      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        ..._corsHeaders,
      });
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

Response _jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
}
