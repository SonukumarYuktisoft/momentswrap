import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:momentswrap/services/shared_preferences_services.dart';

class ApiServices {
  final Dio _dio = Dio();
  // Define your API methods here
  Future<Response> getRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
    required bool authToken,
  }) async {
    log("getRequest url = $url");
    log("getRequest queryParameters = $queryParameters");
    log("getRequest authToken = $authToken");
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          contentType: 'application/json',
          headers: await getHeader(authToken),
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode == 200) {
        log("getRequest response = ${response.data}");
        return response;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log("getRequest error = $e");
    }
    throw Exception('Failed to load data');
  }

  //post request
  Future<Response> postRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
    required bool authToken,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: await getHeader(authToken),

          sendTimeout: const Duration(minutes: 1),
          receiveTimeout: const Duration(minutes: 1),
        ),
      );
      log("postRequest response = ${response.data}");
      return response;
    } catch (e) {
      log("postRequest error = $e");
      rethrow;
    }
  }

  /// POST
  Future<Response?> requestPostForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      Response response = await _dio.post(
        url,
        data: dictParameter,

        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

  // Method to handle PUT requests
  Future<Response> putRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
    required bool authToken,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: await getHeader(authToken),

          sendTimeout: const Duration(minutes: 1),
          receiveTimeout: const Duration(minutes: 1),
        ),
      );
      log("putRequest response = ${response.data}");
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      log("putRequest error = $e");
      rethrow;
    }
  }

  // Method to handle DELETE requests
  Future<Response> deleteRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
    required bool authToken,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await getHeader(authToken),
          sendTimeout: const Duration(minutes: 1),
          receiveTimeout: const Duration(minutes: 1),
        ),
      );
      log("deleteRequest response = ${response.data}");
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      log("deleteRequest error = $e");
      rethrow;
    }
  }

  //put
  Future<Response?> requestPutForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      Response response = await _dio.put(
        url,
        data: dictParameter,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

  /// get headers
  Future<Map<String, String>> getHeader(bool authToken) async {
    if (authToken) {
      String? jwtToken = await SharedPreferencesServices.getJwtToken();
      log("header token = : $jwtToken");

      return {
        "Content-type": "application/json",
        "Authorization": "Bearer $jwtToken",
      };
    } else {
      return {"Content-type": "application/json"};
    }
  }
}
