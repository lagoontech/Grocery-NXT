import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Services/network_util.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;

class HttpService {
  // ignore: non_constant_identifier_names
  static String BASE_URL = ApiConstants().baseUrl;

  //
  static Future<dynamic> postRequest(
      String apiEndPoint, Map<String, dynamic> postData,
      {bool insertHeader = false,bool useBaseUrl = true}) async {
    if(NetworkUtil.connectivityResult == ConnectivityResult.none){
      ToastUtil().showToast(color: Colors.red,message: "No Internet Connection");
      throw NoServiceFoundException('No Service Found');
    }
    late Uri uri;
    if(useBaseUrl) {
      uri = Uri.parse(BASE_URL + apiEndPoint);
    }else{
      uri = Uri.parse(apiEndPoint);
    }
    var client = http.Client();
    print(postData);
    try {
      var response = await client.post(
        uri,
        headers: insertHeader
            ? {
                'content-type': 'application/json',
                'accept': 'application/json',
                'authorization': 'Bearer '+await SharedPrefUtils().getToken(),
                'app-secret-key': ApiConstants().paymentStatusUpdateKey,
              }
            : {'content-type': 'application/json'},
        body: json.encode(postData),
      );
      if(kDebugMode){
        log(response.body);
      }
      return response;
    } on SocketException catch (e) {
      return e;
    } on HttpException {
      throw NoServiceFoundException('No Service Found');
    }
  }

  //
  static Future<dynamic> getRequest(String apiEndPoint,
      {bool insertHeader = true}) async {
    if(NetworkUtil.connectivityResult == ConnectivityResult.none){
      ToastUtil().showToast(color: Colors.red,message: "No Internet Connection");
      throw NoServiceFoundException('No Service Found');
    }
    print(await SharedPrefUtils().getToken());
    var response;
    Uri uri = Uri.parse(BASE_URL + apiEndPoint);
    print(uri.query);
    var client = http.Client();
    try {
      response = await client
          .get(uri,
              headers: insertHeader
                  ? {
                      'content-type': 'application/json',
                      'accept': 'application/json',
                      'authorization': "Bearer "+await SharedPrefUtils().getToken() ?? "",
                      'x-api-key': "b8f4a0ba4537ad6c3ee41ec0a43549d1"
                    }
                  : {'content-type': 'application/json'})
          .timeout(const Duration(seconds: 10), onTimeout: () {
        return http.Response('Timeout', 408);
      });
      if(kDebugMode){
        log(response.body);
      }
      //handleExceptions(response);
      return response;
    } on SocketException catch (e) {
      return e;
    } on HttpException {
      throw NoServiceFoundException('No Service Found');
    }
  }
}

class NoInternetException {
  String message;

  NoInternetException(this.message);
}

class NoServiceFoundException {
  String message;

  NoServiceFoundException(this.message);
}

class InvalidFormatException {
  String message;

  InvalidFormatException(this.message);
}

class UnknownException {
  String message;

  UnknownException(this.message);
}
