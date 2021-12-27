import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/organization/dataModel/is_organization_data_model.dart';
import 'package:insurance/isModel/organization/dataModel/is_tutorial_link_data_model.dart';

class ISOrganizationManager {
  static ISOrganizationManager sharedInstance = ISOrganizationManager();
  List<ISOrganizationDataModel> arrayOrganizations = [];

  ISOrganizationManager() {
    initialize();
  }

  initialize() {
    arrayOrganizations = [];
  }

  ISOrganizationDataModel? getOrganizationById(String? orgId) {
    if (orgId == null || orgId.isEmpty) return null;
    for (ISOrganizationDataModel org in arrayOrganizations) {
      if (org.id == orgId) return org;
    }
    return null;
  }

  ISOrganizationDataModel? getOrganizationByName(String? orgName) {
    if (orgName == null || orgName.isEmpty) return null;
    for (ISOrganizationDataModel org in arrayOrganizations) {
      if (org.szName == orgName) return org;
    }
    return null;
  }

  addOrganizationIfNeeded(ISOrganizationDataModel newOrganization) {
    if (!newOrganization.isValid()) return;

    for (ISOrganizationDataModel org in arrayOrganizations) {
      if (org.id == newOrganization.id) return;
    }
    arrayOrganizations.add(newOrganization);
  }


  List<ISTutorialLinkDataModel> getAllTutorialLinks() {
    List<ISTutorialLinkDataModel> array = [];
    for (ISOrganizationDataModel org in arrayOrganizations) {
      if (org.arrayLinks.length > 0) {
        array.addAll(org.arrayLinks);
      }
    }
    return array;
  }


  requestGetOrganizations(ISNetworkManagerResponse? callback) {
    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      //TODO
      // realm_requestGetOrganizations(callback);
      return;
    }
    String urlString = ISUrlManager.organizationApi
        .getEndpointForGetOrganizations();
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value |
    ISEnumNetworkAuthOptions.authShouldUpdate.value, (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dict = array[i];
            ISOrganizationDataModel org =  ISOrganizationDataModel();
            org.deserialize(dict);
            addOrganizationIfNeeded(org);
            //TODO
            // ISFormManager.sharedInstance().requestGetForms(org.id, null);
          }
          realmSaveAllOrganizations();
        }
        //TODO
        // Intent intent = new Intent(BROADCAST_ORGANIZATION_DATA_FETCHED);
        // LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
      }
      callback?.call(responseModel);
    });
  }


  realmSaveAllOrganizations() {
    //TODO
    // List<RealmOrganizationDataModel> array =[];
    // for(int i = 0; i < arrayOrganizations.length; i ++) {
    //   ISOrganizationDataModel org = arrayOrganizations[i];
    //   RealmOrganizationDataModel realmOrg = new RealmOrganizationDataModel(org.id, org.serializeForOffline());
    //   array.add(realmOrg);
    // }
    // OfflineManager.sharedInstance().write(array);
  }

  realmRequestGetOrganizations(ISNetworkManagerResponse callback) {
    //TODO
    //   RealmResults<RealmOrganizationDataModel> results = OfflineManager.sharedInstance().readObjects(RealmOrganizationDataModel.class);
    //   for(int i = 0; i < results.size(); i ++) {
    //     RealmOrganizationDataModel result = results.get(i);
    //     ISOrganizationDataModel org = result.serializeToDataModel();
    //     this.addOrganizationIfNeeded(org);
    //   }
    //   if(callback != null) callback.onComplete(ISNetworkResponseDataModel.instanceForSuccess());
    // }
  }
}



