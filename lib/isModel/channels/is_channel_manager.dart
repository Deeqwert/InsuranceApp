import 'package:insurance/isModel/channels/dataModel/is_channel_data_model.dart';
import 'package:insurance/isModel/channels/dataModel/is_message_data_model.dart';
import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISChannelManager {
  static ISChannelManager sharedInstance = ISChannelManager();
  List<ISChannelDataModel> arrayChannels = [];

  ISChannelManager() {
    initialize();
  }

  initialize() {
    arrayChannels = [];
  }

  addChannelIfNeeded(ISChannelDataModel newChannel) {
    if (!newChannel.isValid()) return;

    for (ISChannelDataModel channel in arrayChannels) {
      if (channel.id == newChannel.id) return;
    }
    arrayChannels.add(newChannel);
  }

  requestGetChannels(ISNetworkManagerResponse? callback) {
    if (!ISUserManager.sharedInstance.isLoggedIn()) {
      callback?.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }

    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      callback?.call(ISNetworkResponseDataModel.instanceForSuccess());
      return;
    }

    String urlString = ISUrlManager.channelApi.getEndpointForGetChannels(
        ISUserManager.sharedInstance.currentUser!.id);

    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dict = array[i];
            ISChannelDataModel channel = ISChannelDataModel();
            channel.deserialize(dict);
            addChannelIfNeeded(channel);
          }
        }
        ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.channelListUpdated);

      }
      callback?.call(responseModel);
    });
  }

  requestGetChannelMessages(
      ISChannelDataModel channel, ISNetworkManagerResponse callback) {
    String urlString =
        ISUrlManager.channelApi.getEndpointForGetChannelMessages(ISUserManager.sharedInstance.currentUser!.id,channel.id);
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dic = array[i];
            ISMessageDataModel message = ISMessageDataModel();
            message.deserialize(dic);
            channel.addMessageIfNeeded(message);
          }
          ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.messageListUpdated);
        }
        callback.call(responseModel);
      }
    });
  }

  requestSendChannelMessage(ISChannelDataModel channel, String message,
      ISNetworkManagerResponse callback) {
    String urlString =
        ISUrlManager.channelApi.getEndpointForSendChannelMessage(ISUserManager.sharedInstance.currentUser!.id,channel.id);

    Map<String, dynamic> params = {"message": message};

    ISNetworkManager.post(
        urlString, params, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        ISMessageDataModel message = ISMessageDataModel();
        message.deserialize(responseModel.payload);

        if (message.isValid()) {
          channel.addMessageIfNeeded(message);
          ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.messageListUpdated);
        }
      }
      callback.call(responseModel);
    });
  }
}
