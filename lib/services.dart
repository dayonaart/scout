import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

BaseOptions get _baseDioOption {
  return BaseOptions(connectTimeout: 60000, baseUrl: "");
}

Future<ConnectivityResult> checkNetwork() async {
  return await (Connectivity().checkConnectivity());
}

Future<WrapResponse?> POST({
  @required String? endpoint,
  @required dynamic payload,
  bool showErrorSnackbar = false,
}) async {
  var net = await checkNetwork();
  try {
    var execute = Dio(_baseDioOption).post(endpoint!, data: payload);
    var res = await execute;
    return WrapResponse(message: res.statusMessage, statusCode: res.statusCode, data: res.data);
  } on DioError catch (e) {
    if (e.type == DioErrorType.response) {
      showErrorSnackbar ? ERROR_DIALOG(e.response?.statusMessage) : null;
      return WrapResponse(
          message: e.response?.statusMessage ?? e.message,
          statusCode: e.response?.statusCode ?? 0,
          data: e.error);
    } else if (e.type == DioErrorType.connectTimeout) {
      showErrorSnackbar ? ERROR_DIALOG("Koneksi tidak stabil") : null;
      return WrapResponse(message: "connection timeout", statusCode: e.response?.statusCode ?? 0);
    } else if (net == ConnectivityResult.none) {
      ERROR_DIALOG("Pastikan Anda terhubung ke Internet");
      return WrapResponse(message: "connection timeout", statusCode: 000);
    } else {
      ERROR_DIALOG("Terjadi Kesalahan");
      return WrapResponse(message: "connection timeout", statusCode: 999);
    }
  }
}

void SUCCESS_DIALOG(String? title, String? message) {
  Get.rawSnackbar(
      message: message,
      title: title,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      isDismissible: true,
      duration: const Duration(seconds: 4));
}

void ERROR_DIALOG(String? message) {
  Get.rawSnackbar(
      message: message,
      title: "Perhatian",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      isDismissible: true,
      duration: const Duration(seconds: 4));
}

class WrapResponse {
  String? message;
  int? statusCode;
  dynamic data;
  WrapResponse({
    this.message,
    this.statusCode,
    this.data,
  });
  WrapResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    statusCode = json['code'];
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status_code'] = statusCode;
    _data['data'] = data;
    return _data;
  }
}
