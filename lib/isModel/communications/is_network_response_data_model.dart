import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISNetworkResponseDataModel {
  Map<String, dynamic> payload = {};
  dynamic parsedObject;
  int code = EnumNetworkResponseCode.code200OK.value;

  String errorMessage = "";
  EnumNetworkErrorCode errorCode = EnumNetworkErrorCode.userInvalidCredentials;

  ISNetworkResponseDataModel() {
    initialize();
  }

  initialize() {
    payload = {};
    parsedObject = null;
    code = EnumNetworkResponseCode.code200OK.value;
    errorMessage = "";
    errorCode = EnumNetworkErrorCode.userInvalidCredentials;
  }

  bool isSuccess() {
    return (code == EnumNetworkResponseCode.code200OK.value ||
        code == EnumNetworkResponseCode.code204NoContent.value ||
        code == EnumNetworkResponseCode.code201Created.value);
  }

  bool isTokenExpired() {
    return (code == EnumNetworkResponseCode.code403Forbidden.value) &&
        errorCode == EnumNetworkErrorCode.tokenExpired;
  }

  bool isServiceUnreachable() {
    return (code == EnumNetworkResponseCode.code408Timeout.value ||
        code == EnumNetworkResponseCode.code502BadGateway.value ||
        code == EnumNetworkResponseCode.code503ServiceUnavailable.value ||
        code == EnumNetworkResponseCode.code504GatewayTimeout.value ||
        code == EnumNetworkResponseCode.code0Unreachable.value);
  }

  bool isAuthFailed() {
    return (code == EnumNetworkResponseCode.code401Unauthorized.value ||
        code == EnumNetworkResponseCode.code403Forbidden.value);
  }

  bool isOffline() {
    return (code == EnumNetworkResponseCode.code502BadGateway.value ||
        code == EnumNetworkResponseCode.code400BadRequest.value);
  }

  String getBeautifiedErrorMessage() {
    if (isSuccess()) return "";
    if (errorMessage.isNotEmpty) return errorMessage;
    return "Sorry, we've encountered an unknown error.";
  }

  static ISNetworkResponseDataModel instanceFromDataResponse(
      http.Response response, bool shouldUpdateToken) {
    if (response.isSuccessful() && shouldUpdateToken) {
      final xAuth = response.headers["x-auth"];
      if (xAuth != null) {
        ISUserManager.sharedInstance.updateAuthToken(xAuth);
        ISUtilsGeneral.log("Updated User Token = " + xAuth);
      }
    }
    final modelResponse = ISNetworkResponseDataModel();
    try {
      modelResponse.code = response.statusCode;
      if (response.statusCode ==
          EnumNetworkResponseCode.code401Unauthorized.value) {
        modelResponse.payload = {};
        return modelResponse;
      }
      ISUtilsGeneral.log("response : " + response.body);
      if (response.body != "") {
        final Map<String, dynamic> jsonObject = jsonDecode(response.body);
        modelResponse.payload = jsonObject;
        if (jsonObject.containsKey("error")) {
          modelResponse.errorMessage =
              ISUtilsString.refineString(jsonObject["error"]);
        }
        if (jsonObject.containsKey("message")) {
          modelResponse.errorMessage =
              ISUtilsString.refineString(jsonObject["message"]);
        }
        if (jsonObject.containsKey("name")) {
          modelResponse.errorCode = NetworkErrorCodeExtension.fromString(
              ISUtilsString.refineString(jsonObject["name"]));
        }
      } else {
        modelResponse.payload = {};
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
      return instanceForFailure();
    }

    return modelResponse;
  }

  //For handling bad request
  static ISNetworkResponseDataModel instanceFromBadResponse(
      http.Response? response) {
    final modelResponse = ISNetworkResponseDataModel();
    if (response == null) {
      modelResponse.code = EnumNetworkResponseCode.code502BadGateway.value;
      modelResponse.errorMessage = "Sorry, we've encountered an unknown error.";
      return modelResponse;
    }

    ISUtilsGeneral.log("response : " + response.body);
    final Map<String, dynamic> jsonObject = jsonDecode(response.body);
    modelResponse.payload = jsonObject;
    modelResponse.code = response.statusCode;

    if (jsonObject.containsKey("message")) {
      modelResponse.errorMessage =
          ISUtilsString.refineString(jsonObject["message"]);
    }
    ISUtilsGeneral.log(
        "[NetworkManager - Message - ${modelResponse.errorMessage} - Code - ${modelResponse.code}");
    return modelResponse;
  }

  static ISNetworkResponseDataModel instanceForFailure() {
    final instance = ISNetworkResponseDataModel();
    instance.code = EnumNetworkResponseCode.code400BadRequest.value;
    return instance;
  }

  static ISNetworkResponseDataModel instanceForSuccess() {
    final instance = ISNetworkResponseDataModel();
    return instance;
  }
}

extension ResponseStatus on http.Response {
  bool isSuccessful() {
    return (statusCode / 100) == 2;
  }
}

enum EnumNetworkResponseCode {
  code200OK,
  code201Created,
  code204NoContent,
  code400BadRequest,
  code401Unauthorized,
  code403Forbidden,
  code404NotFound,
  code408Timeout,
  code500ServerError,
  code502BadGateway,
  code503ServiceUnavailable,
  code504GatewayTimeout,
  code0Unreachable
}

extension UserStatusExtension on EnumNetworkResponseCode {
  int get value {
    switch (this) {
      case EnumNetworkResponseCode.code200OK:
        return 200;
      case EnumNetworkResponseCode.code201Created:
        return 201;
      case EnumNetworkResponseCode.code204NoContent:
        return 204;
      case EnumNetworkResponseCode.code400BadRequest:
        return 400;
      case EnumNetworkResponseCode.code401Unauthorized:
        return 401;
      case EnumNetworkResponseCode.code403Forbidden:
        return 403;
      case EnumNetworkResponseCode.code404NotFound:
        return 404;
      case EnumNetworkResponseCode.code408Timeout:
        return 408;
      case EnumNetworkResponseCode.code500ServerError:
        return 500;
      case EnumNetworkResponseCode.code502BadGateway:
        return 502;
      case EnumNetworkResponseCode.code503ServiceUnavailable:
        return 503;
      case EnumNetworkResponseCode.code504GatewayTimeout:
        return 504;
      case EnumNetworkResponseCode.code0Unreachable:
        return 0;
    }
  }
}

enum EnumNetworkErrorCode {
  none,
  unknown,
  userInvalidCredentials,
  tokenExpired
}

extension NetworkErrorCodeExtension on EnumNetworkErrorCode {
  static EnumNetworkErrorCode fromString(String? status) {
    if (status == null || status.isEmpty) {
      return EnumNetworkErrorCode.unknown;
    }
    for (var t in EnumNetworkErrorCode.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return EnumNetworkErrorCode.unknown;
  }

  String get value {
    switch (this) {
      case EnumNetworkErrorCode.none:
        return "";
      case EnumNetworkErrorCode.unknown:
        return "UNKNOWN_ERROR";
      case EnumNetworkErrorCode.userInvalidCredentials:
        return "INVALID_CREDENTIALS_ERROR";
      case EnumNetworkErrorCode.tokenExpired:
        return "ExpiredTokenError";
    }
  }
}
