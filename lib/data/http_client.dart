// lib/data/http_client.dart

import 'package:dio/dio.dart';
import 'package:stack_crud_flutter/data/services/storage_service.dart';

class HttpClient {
  // Create a private constructor for the singleton pattern.
  HttpClient._();

  // The single, static instance of Dio.
  static final Dio dioInstance = _createDioInstance();

  static Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8080/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add the interceptor immediately upon creation.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService().readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  }
}
