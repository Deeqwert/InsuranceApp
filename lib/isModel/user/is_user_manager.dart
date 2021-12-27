import 'dart:convert';
import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/localStorage/is_local_storage_manager.dart';
import 'package:insurance/isModel/pushNotification/is_push_notification_manager.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';

class ISUserManager {
  static ISUserManager sharedInstance = ISUserManager();
  static String localStorageKey = "USER";
  ISUserDataModel? currentUser;
  String authToken = "";
  ISUserManager() {
    initialize();
  }

  initialize() {
    currentUser = null;
  }

  String getAuthToken() {
    return authToken;
  }

  updateAuthToken(String? token) {
    if (token == null) return;
    if (token.isNotEmpty) {
      authToken = token;
    }
  }

  bool isLoggedIn() {
    return (currentUser != null &&
        authToken.isNotEmpty &&
        currentUser!.id.isNotEmpty);
  }

  saveToLocalStorage() {
    if (!isLoggedIn()) return;

    ISUtilsGeneral.log(currentUser!.serializeForLocalStorage().toString());

    Map<String, dynamic> params = {};

    params["user_data"] =
        jsonEncode(currentUser!.serializeForLocalStorage()).toString();
    params["auth_token"] = authToken;

    ISLocalStorageManager.saveGlobalObject(
        jsonEncode(params).toString(), localStorageKey);
  }

  loadFromLocalStorage() async {
    final String? strParams =
        await ISLocalStorageManager.loadGlobalObjectForKey(localStorageKey);
    if (strParams == null || strParams.isEmpty) {
      currentUser = null;
      return;
    }
    currentUser = ISUserDataModel();
    final Map<String, dynamic> dictUserData = jsonDecode(strParams);
    if (dictUserData.containsKey("user_data")) {
      currentUser!.deserialize(jsonDecode(dictUserData["user_data"]));
    }
    if (dictUserData.containsKey("auth_token")) {
      authToken = ISUtilsString.refineString(dictUserData["auth_token"]);
    }
  }

  requestUserLogin(
      String email, String password, ISNetworkManagerResponse callback) {
    String urlString = ISUrlManager.userApi.getEndpointForUserLogin();

    Map<String, dynamic> params = {};
    params["email"] = email;
    params["password"] = password;

    ISNetworkManager.post(
        urlString, params, ISEnumNetworkAuthOptions.authShouldUpdate.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        currentUser = new ISUserDataModel();
        currentUser!.deserialize(responseModel.payload);
        currentUser!.szPassword = password;

        //TODO:
        ISUtilsGeneral.log("[User Login] token = " + authToken);
      }
      callback.call(responseModel);
    });
  }

  requestUserSignup(String name, String username, String email, String phone,
      String password, ISNetworkManagerResponse callback) {
    String urlString = ISUrlManager.userApi.getEndpointForUserSignup();

    Map<String, dynamic> params = {};

    params["name"] = name;
    params["username"] = username;
    params["email"] = email;
    params["phone"] = phone;
    params["password"] = password;

    ISNetworkManager.post(
        urlString, params, ISEnumNetworkAuthOptions.authShouldUpdate.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        currentUser = new ISUserDataModel();
        currentUser!.deserialize(responseModel.payload);
        currentUser!.szPassword = password;
      }
      callback.call(responseModel);
    });
  }

  requestUserForgotPassword(String email, ISNetworkManagerResponse callback) {
    String urlString = ISUrlManager.userApi.getEndpointForUserForgotPassword();

    Map<String, dynamic> params = {};
    params["email"] = email;

    ISNetworkManager.post(
        urlString, params, ISEnumNetworkAuthOptions.authNone.value,
        (responseModel) {
      callback.call(responseModel);
    });
  }

  requestUpdateUserWithDictionary(
      Map<String, dynamic> dictionary, ISNetworkManagerResponse callback) {
    String urlString =
        ISUrlManager.userApi.getEndpointForUserUpdate(currentUser!.id);

    ISNetworkManager.put(
        urlString,
        dictionary,
        ISEnumNetworkAuthOptions.authRequired.value |
            ISEnumNetworkAuthOptions.authShouldUpdate.value, (responseModel) {
      if (responseModel.isSuccess()) {
        currentUser!.deserialize(responseModel.payload);
        if (dictionary.containsKey("password")) {
          currentUser!.szPassword =
              ISUtilsString.refineString(dictionary["password"]);
        }
      }
      callback.call(responseModel);
    });
  }

  requestUpdateUserPushToken(
      String? pushToken, ISNetworkManagerResponse? callback) {
    if (pushToken == null || pushToken.isEmpty) {
      if (callback != null)
        callback.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }

    String userId = "";
    if (currentUser != null) {
      userId = currentUser!.id;
    }

    String urlString = ISUrlManager.userApi.getEndpointForUserUpdate(userId);
    Map<String, dynamic> params = {};

    params["deviceToken"] = pushToken;

    ISNetworkManager.put(
        urlString, params, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      //TODO:
      currentUser!.szDeviceToken = ISPushNotificationManager.sharedInstance.fcmToken!;
      saveToLocalStorage();

      callback?.call(responseModel);
    });
  }
}
