class ISPushNotificationManager {
  static ISPushNotificationManager sharedInstance = ISPushNotificationManager();
  String? fcmToken;
  ISPushNotificationManager() {
    initialize();
  }
  initialize() {
    fcmToken = null;
  }
}
