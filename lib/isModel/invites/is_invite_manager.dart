import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/invites/dataModel/is_invite_data_model.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISInviteManager {
  static ISInviteManager sharedInstance = ISInviteManager();
  List<ISInviteDataModel> arrayInvites = [];

  ISInviteManager() {
    initialize();
  }

  initialize() {
    arrayInvites = [];
  }

  addInviteIfNeeded(ISInviteDataModel newInvite) {
    if (!newInvite.isValid()) return;
    for (ISInviteDataModel invite in arrayInvites) {
      if (invite.id == newInvite.id) return;
    }
    arrayInvites.add(newInvite);
  }

  List<ISInviteDataModel> getPendingInvites() {
    List<ISInviteDataModel> array = [];
    for (ISInviteDataModel invite in arrayInvites) {
      if (invite.enumStatus.value == ISEnumInvitationStatus.pending.value) {
        array.add(invite);
      }
    }
    return array;
  }

  requestGetInvites(ISNetworkManagerResponse? callback) {
    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      if (callback != null)
        callback.call(ISNetworkResponseDataModel.instanceForSuccess());
      return;
    }
    if (!ISUserManager.sharedInstance.isLoggedIn()) {
      if (callback != null)
        callback.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }

    String urlString = ISUrlManager.inviteApi
        .getEndpointForGetInvites(ISUserManager.sharedInstance.currentUser!.id);
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dict = array[i];
            ISInviteDataModel invite = ISInviteDataModel();
            invite.deserialize(dict);
            addInviteIfNeeded(invite);
          }
        }
        //TODO
//              Intent intent = new Intent(BROADCAST_INVITE_LISTUPDATED);
//              LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
//            }
//            if(callback != null) callback.onComplete(responseModel);
//              }
      }
      callback?.call(responseModel);
    });
  }

  requetAcceptInvite(
      ISInviteDataModel invite, ISNetworkManagerResponse callback) {
    String urlString =
        ISUrlManager.inviteApi.getEndpointForAcceptInvite(invite.token);

    ISNetworkManager.post(
        urlString,
        {},
        ISEnumNetworkAuthOptions.authRequired.value |
            ISEnumNetworkAuthOptions.authShouldUpdate.value, (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dic = array[i];
            ISInviteDataModel invite = ISInviteDataModel();
            invite.deserialize(dic);
            addInviteIfNeeded(invite);
          }
          //TODO
          //      Intent intent = new Intent(BROADCAST_INVITE_LISTUPDATED);
          //      LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
          //   }
          //   callback.onComplete(responseModel);
          // }
        }
      }
      callback.call(responseModel);
    });
  }

  requestAcceptInvite(
      ISInviteDataModel invite, ISNetworkManagerResponse callback) {
    String urlString =
    ISUrlManager.inviteApi.getEndpointForAcceptInvite(invite.token);
    ISNetworkManager.post(
        urlString,
        {},
        ISEnumNetworkAuthOptions.authRequired.value |
        ISEnumNetworkAuthOptions.authShouldUpdate.value, (responseModel) {
      if (responseModel.isSuccess()) {
        invite.enumStatus = ISEnumInvitationStatus.accepted;

        ISOrganizationManager.sharedInstance.requestGetOrganizations((
            responseModel) {
          if (responseModel.isSuccess()) {}
          callback.call(responseModel);

          //TODO: ISClaimManager
          // ISClaimManager.sharedInstance.requestGetTasks((responseModel) {
          //   if (responseModel.isSuccess()) {}
          //   callback.call(responseModel);
          // });

        });
      }
    });
  }

  requestDeclineInvite(
      ISInviteDataModel invite, ISNetworkManagerResponse callback) {
    String urlString =
    ISUrlManager.inviteApi.getEndpointForDeclineInvite(invite.token);
    ISNetworkManager.post(
        urlString,
        {},
        ISEnumNetworkAuthOptions.authRequired.value |
        ISEnumNetworkAuthOptions.authShouldUpdate.value, (responseModel) {
      if (responseModel.isSuccess()) {
        invite.enumStatus = ISEnumInvitationStatus.declined;
      }
      callback.call(responseModel);
    });
  }
}
