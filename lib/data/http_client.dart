// lib/data/http_client.dart (Membuat Dio Client dengan Interceptor)

import 'package:dio/dio.dart';
import 'services/storage_service.dart';

class HttpClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080/api/v1', // Base URL API Golang Anda
  ));

  static Dio get dioInstance {
    // Tambahkan Interceptor untuk JWT
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService().getAccessToken();
        if (token != null) {
          // Menyuntikkan token ke Header Authorization
          options.headers['Authorization'] = 'Bearer $token'; 
        }
        return handler.next(options);
      },
      // Tambahkan logic untuk menangani HTTP 401 dan Refresh Token di sini
    ));
    return _dio;
  }
}