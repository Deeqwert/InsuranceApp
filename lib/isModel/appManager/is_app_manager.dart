import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:insurance/isModel/appManager/dataModel/is_app_setting_data_model.dart';
import 'package:insurance/isModel/channels/is_channel_manager.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/forms/is_form_manager.dart';
import 'package:insurance/isModel/invites/is_invite_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localStorage/is_local_storage_manager.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';
import 'package:insurance/isModel/pushNotification/is_push_notification_manager.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISAppManager {
  static ISAppManager sharedInstance = ISAppManager();
  ISAppSettingDataModel modelSettings = ISAppSettingDataModel();
  static String localStorageKey = "APP_SETTINGS";

  ISAppManager() {
    initialize();
  }

  initialize() {
    modelSettings = ISAppSettingDataModel();
  }

  initializeManagers() {
    ISOrganizationManager.sharedInstance.initialize();
  }

  initializeManagersAfterLaunch() {
    //TODO: Offline Manager
  }

  initializeManagersAfterLogin() {
    ISOrganizationManager.sharedInstance.requestGetOrganizations(null);
    ISClaimManager.sharedInstance.requestGetTasks(null);
    ISInviteManager.sharedInstance.requestGetInvites(null);
    ISChannelManager.sharedInstance.requestGetChannels(null);
    // ISFormManager.sharedInstance.requestGetAllForms();

    // TODO Update

    // TODO: get fcm token
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      ISPushNotificationManager.sharedInstance.fcmToken = token;
      if(ISPushNotificationManager.sharedInstance.fcmToken!=null && ISPushNotificationManager.sharedInstance.fcmToken!.isNotEmpty){
        ISUserManager.sharedInstance.requestUpdateUserPushToken(ISPushNotificationManager.sharedInstance.fcmToken, null);
      }
      ISUtilsGeneral.log("TOKEN "+token!);
    });
    //TODO: load pending request offline
    // OfflineManager.sharedInstance.loadPendingRequests();
  }
  initializeManagersAfterLogout() {
    ISOrganizationManager.sharedInstance.initialize();
    ISClaimManager.sharedInstance.initialize();
    ISInviteManager.sharedInstance.initialize();
    ISChannelManager.sharedInstance.initialize();
    ISFormManager.sharedInstance.initialize();
  }

  // Localstorage

  saveToLocalStorage() {
    final params = jsonEncode(modelSettings.serialize());
    ISLocalStorageManager.saveGlobalObject(params.toString(), localStorageKey);
  }

  loadFromLocalStorage() async {
    final strParams =
        await ISLocalStorageManager.loadGlobalObjectForKey(localStorageKey);
    if (strParams == null || strParams == "") {
      modelSettings.initialize();
      return;
    }
    final Map<String, dynamic> dictSettingData = jsonDecode(strParams);
    modelSettings.deserialize(dictSettingData);
  }
}
