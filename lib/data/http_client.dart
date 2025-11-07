// lib/data/http_client.dart

import 'package:dio/dio.dart';
// Import StorageService jika Anda ingin menambahkan Interceptor JWT di sini
// import 'package:stack_crud_flutter/data/services/storage_service.dart';
// import 'config/app_config.dart'; // Jika Anda punya Base URL di config

class HttpClient {
  static final Dio _dio = Dio(
    BaseOptions(
      // Ganti dengan BASE_URL Golang Anda!
      baseUrl: 'http://10.0.2.2:8080/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get dioInstance {
    // Di sini Anda dapat menambahkan Interceptor untuk JWT
    // if (_dio.interceptors.isEmpty) {
    //   _dio.interceptors.add(
    //     InterceptorsWrapper(
    //       onRequest: (options, handler) async {
    //         final token = await StorageService().readToken();
    //         if (token != null) {
    //           options.headers['Authorization'] = 'Bearer $token';
    //         }
    //         return handler.next(options);
    //       },
    //       // Tambahkan logika Refresh Token di sini jika perlu
    //     ),
    //   );
    // }
    return _dio;
  }
}
