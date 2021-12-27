import 'dart:convert';
import 'dart:io';

import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_offline_request_data_model.dart';
import 'package:insurance/isModel/communications/is_offline_request_manager.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_file.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';

import 'package:http/http.dart' as http;
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISNetworkManager {
  static get(String endpoint, Map<String, dynamic>? params, int authOptions,
      ISNetworkManagerResponse callback,
      {bool retryRequest = true}) {
    var urlString = endpoint;
    if (params != null) {
      urlString = "$urlString?";
      final keys = params.keys;
      for (var element in keys) {
        final String key = element;
        final dynamic value = params[key];
        urlString = "$urlString$key=$value&";
      }
    }
    if (urlString.endsWith('&')) {
      urlString = urlString.substring(0, urlString.length - 1);
    }
    final sessionToken = ISUtilsString.generateRandomString(16);
    ISUtilsGeneral.log("[NetworkManager - ($sessionToken)] - GET: $urlString");
    Map<String, String> headers = {};
    if ((authOptions & ISEnumNetworkAuthOptions.authRequired.value) > 0 &&
        ISUserManager.sharedInstance.isLoggedIn()) {
      headers["x-auth"] = ISUserManager.sharedInstance.getAuthToken();
    }
    final httpRequest = ISOfflineRequestDataModel();
    httpRequest.params = params;
    httpRequest.authOptions = authOptions;
    httpRequest.endpoint = endpoint;
    httpRequest.callback = (responseDataModel) {};
    httpRequest.method = "GET";
    http.get(Uri.parse(urlString), headers: headers).then((value) {
      if (value.statusCode < 200 || value.statusCode >= 400) {
        final result =
            ISNetworkResponseDataModel.instanceFromBadResponse(value);
        if (result.isTokenExpired() && retryRequest) {
          _refreshAndRetry(httpRequest, authOptions, callback);
        } else {
          callback.call(result);
        }
      } else {
        final result = ISNetworkResponseDataModel.instanceFromDataResponse(
            value,
            ((authOptions & ISEnumNetworkAuthOptions.authShouldUpdate.value) >
                0));
        callback.call(result);
      }
    }).onError((error, stackTrace) {
      ISUtilsGeneral.log("RRRRRR "+error.toString());
      if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
        ISOfflineRequestManager.sharedInstance.enqueueRequest(httpRequest);
      }
      final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
      callback.call(result);
    });
  }

  static _refreshAndRetry(ISOfflineRequestDataModel originalHttpRequest,
      int authOptions, ISNetworkManagerResponse callback) {
    // first we need to update the token

    final urlString = ISUrlManager.userApi.getEndpointForUserTokenRefresh(
        ISUserManager.sharedInstance.getAuthToken());

    http.get(Uri.parse(urlString)).then((value) {
      if (value.statusCode < 200 || value.statusCode >= 400) {
        final result =
            ISNetworkResponseDataModel.instanceFromBadResponse(value);
        callback.call(result);
      } else {
        ISNetworkResponseDataModel.instanceFromDataResponse(value, true);

        final method = originalHttpRequest.method;
        if (method == null) return;
        if (method == "PUT") {
          ISNetworkManager.put(
              originalHttpRequest.endpoint,
              originalHttpRequest.params,
              originalHttpRequest.authOptions, (responseDataModel) {
            callback.call(responseDataModel);
          }, retryRequest: false);
        } else if (method == "GET") {
          ISNetworkManager.get(
              originalHttpRequest.endpoint,
              originalHttpRequest.params,
              originalHttpRequest.authOptions, (responseDataModel) {
            callback.call(responseDataModel);
          }, retryRequest: false);
        } else if (method == "POST") {
          ISNetworkManager.post(
              originalHttpRequest.endpoint,
              originalHttpRequest.params,
              originalHttpRequest.authOptions, (responseDataModel) {
            callback.call(responseDataModel);
          }, retryRequest: false);
        }
      }
    }).onError((error, stackTrace) {
      final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
      callback.call(result);
    });
  }

  static post(String urlString, Map<String, dynamic>? params, int authOptions,
      ISNetworkManagerResponse callback,
      {bool retryRequest = true}) {
    final sessionToken = ISUtilsString.generateRandomString(16);
    ISUtilsGeneral.log("[NetworkManager - ($sessionToken)] - POST: $urlString");
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = "application/json";
    headers[HttpHeaders.acceptHeader] = "application/json";
    if ((authOptions & ISEnumNetworkAuthOptions.authRequired.value) > 0 &&
        ISUserManager.sharedInstance.isLoggedIn()) {
      headers["x-auth"] = ISUserManager.sharedInstance.getAuthToken();
    }
    final httpRequest = ISOfflineRequestDataModel();
    httpRequest.params = params;
    httpRequest.authOptions = authOptions;
    httpRequest.endpoint = urlString;
    httpRequest.callback = (responseDataModel) {};
    httpRequest.method = "POST";
    http
        .post(Uri.parse(urlString), headers: headers, body: jsonEncode(params))
        .then((value) {
      if (value.statusCode < 200 || value.statusCode >= 400) {
        final result =
            ISNetworkResponseDataModel.instanceFromBadResponse(value);
        if (result.isTokenExpired() && retryRequest) {
          _refreshAndRetry(httpRequest, authOptions, callback);
        } else {
          callback.call(result);
        }
      } else {
        final result = ISNetworkResponseDataModel.instanceFromDataResponse(
            value,
            ((authOptions & ISEnumNetworkAuthOptions.authShouldUpdate.value) >
                0));
        callback.call(result);
      }
    }).onError((error, stackTrace) {
      if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
        ISOfflineRequestManager.sharedInstance.enqueueRequest(httpRequest);
      }
      final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
      callback.call(result);
    });
  }

  static put(String urlString, Map<String, dynamic>? params, int authOptions,
      ISNetworkManagerResponse callback,
      {bool retryRequest = true}) {
    final sessionToken = ISUtilsString.generateRandomString(16);
    ISUtilsGeneral.log("[NetworkManager - ($sessionToken)] - PUT: $urlString");
    ISUtilsGeneral.log(
        "[NetworkManager - ($sessionToken)] - PUT: ${params!.toString()}");
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = "application/json";
    headers[HttpHeaders.acceptHeader] = "application/json";
    if ((authOptions & ISEnumNetworkAuthOptions.authRequired.value) > 0 &&
        ISUserManager.sharedInstance.isLoggedIn()) {
      headers["x-auth"] = ISUserManager.sharedInstance.getAuthToken();
    }
    final httpRequest = ISOfflineRequestDataModel();
    httpRequest.params = params;
    httpRequest.authOptions = authOptions;
    httpRequest.endpoint = urlString;
    httpRequest.callback = (responseDataModel) {};
    httpRequest.method = "PUT";
    http
        .put(Uri.parse(urlString), headers: headers, body: jsonEncode(params))
        .then((value) {
      if (value.statusCode < 200 || value.statusCode >= 400) {
        final result =
            ISNetworkResponseDataModel.instanceFromBadResponse(value);
        if (result.isTokenExpired() && retryRequest) {
          _refreshAndRetry(httpRequest, authOptions, callback);
        } else {
          callback.call(result);
        }
      } else {
        final result = ISNetworkResponseDataModel.instanceFromDataResponse(
            value,
            ((authOptions & ISEnumNetworkAuthOptions.authShouldUpdate.value) >
                0));
        callback.call(result);
      }
    }).onError((error, stackTrace) {
      if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
        ISOfflineRequestManager.sharedInstance.enqueueRequest(httpRequest);
      }
      final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
      callback.call(result);
    });
  }

  static upload(String endPoint, String fileName,
      File file, int authOptions, ISNetworkManagerResponse callback) {
    final sessionToken = ISUtilsString.generateRandomString(16);
    ISUtilsGeneral.log(
        "[NetworkManager - ($sessionToken)] - UPLOAD FILE: $endPoint");
    var request = http.MultipartRequest("POST", Uri.parse(endPoint));
    http.MultipartFile.fromPath("file", file.path).then((multipartFile) {
      request.files.add(multipartFile);
      if ((authOptions & ISEnumNetworkAuthOptions.authRequired.value) > 0 &&
          ISUserManager.sharedInstance.isLoggedIn()) {
        request.headers["x-auth"] = ISUserManager.sharedInstance.getAuthToken();
        request.headers[HttpHeaders.contentTypeHeader] = "multipart/form-data";
      }
      request.send().then((streamedResponse) {
        http.Response.fromStream(streamedResponse).then((value) {
          if (value.statusCode < 200 || value.statusCode >= 400) {
            final result =
                ISNetworkResponseDataModel.instanceFromBadResponse(value);
            callback.call(result);
          } else {
            final result = ISNetworkResponseDataModel.instanceFromDataResponse(
                value,
                ((authOptions & ISEnumNetworkAuthOptions.authShouldUpdate.value) >
                    0));
            callback.call(result);
          }
        }).onError((error, stackTrace) {
          final result =
              ISNetworkResponseDataModel.instanceFromBadResponse(null);
          callback.call(result);
        });
      }).onError((error, stackTrace) {
        final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
        callback.call(result);
      });
    });
  }

  static download(String endpoint, String mimeType, String mediaId,
      int authOptions, ISNetworkManagerResponse callback) {
    final sessionToken = ISUtilsString.generateRandomString(16);
    ISUtilsGeneral.log(
        "[NetworkManager - ($sessionToken)] - DOWNLOAD FILE: $endpoint");
    Map<String, String> headers = {};
    if ((authOptions & ISEnumNetworkAuthOptions.authRequired.value) > 0 &&
        ISUserManager.sharedInstance.isLoggedIn()) {
      headers["x-auth"] = ISUserManager.sharedInstance.getAuthToken();
    }
    http.get(Uri.parse(endpoint), headers: headers).then((value) async {
      if (value.statusCode < 200 || value.statusCode >= 400) {
        final result =
            ISNetworkResponseDataModel.instanceFromBadResponse(value);
        callback.call(result);
      } else {
        File file = await ISUtilsFile.createPNGFile(mediaId);
        await file.writeAsBytes(value.bodyBytes);
        final result = ISNetworkResponseDataModel.instanceFromDataResponse(
            value,
            ((authOptions & ISEnumNetworkAuthOptions.authShouldUpdate.value) >
                0));
        callback.call(result);
      }
    }).onError((error, stackTrace) {
      final result = ISNetworkResponseDataModel.instanceFromBadResponse(null);
      callback.call(result);
    });
  }
}

enum ISEnumNetworkAuthOptions { authNone, authRequired, authShouldUpdate }

extension NetworkAuthOptionsExtension on ISEnumNetworkAuthOptions {
  int get value {
    switch (this) {
      case ISEnumNetworkAuthOptions.authNone:
        return 00000000;
      case ISEnumNetworkAuthOptions.authRequired:
        return 00000001;
      case ISEnumNetworkAuthOptions.authShouldUpdate:
        return 00000010;
    }
  }
}
