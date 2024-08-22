import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final Dio _dio = Dio();

  NetworkApiServices() {
    // Optionally configure Dio settings here
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
  }

  @override
  Future<dynamic> getApi(String url) async {
    print("Calling GET API: $url");

    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = returnResponse(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        throw InternetException('');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw RequestTimeOut('');
      } else if (e.type == DioExceptionType.connectionError) {
        throw InternetException('');
      } else {
        throw FetchDataException(e.message);
      }
    }
    print(responseJson);
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        return response.data;
      default:
        throw FetchDataException(
            'Error occurred with status code: ${response.statusCode}');
    }
  }
}
