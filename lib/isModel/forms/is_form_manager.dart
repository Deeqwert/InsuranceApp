import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_definition_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_submission_data_model.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/organization/dataModel/is_organization_data_model.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';

class ISFormManager {
  static ISFormManager sharedInstance = ISFormManager();

  ISFormManager() {
    initialize();
  }

  List<ISFormDefinitionDataModel> arrayForms = [];

  initialize() {
    arrayForms = [];
  }

  addFormIfNeeded(ISFormDefinitionDataModel newForm) {
    if (!newForm.isValid()) return;
    int index = 0;
    for (ISFormDefinitionDataModel form in arrayForms) {
      if (form.id == newForm.id) {
        arrayForms.insert(index, newForm);
        return;
      }
      index++;
    }
    arrayForms.add(newForm);
  }

  ISFormDefinitionDataModel? getPrimaryFormOrganization(String organizationId) {
    for (ISFormDefinitionDataModel form in arrayForms) {
      if (form.organizationId == organizationId) return form;
    }
    return null;
  }

  ISFormDefinitionDataModel? getFormById(String formId) {
    for (ISFormDefinitionDataModel form in this.arrayForms) {
      if (form.id == formId) return form;
    }
    return null;
  }

  requestGetAllForms() {
    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      return;
    }
    List<ISOrganizationDataModel> arrayList =
        ISOrganizationManager.sharedInstance.arrayOrganizations;
    if (arrayList.isNotEmpty) {
      for (int i = 0; i < arrayList.length; i++) {
        String urlString =
            ISUrlManager.locationApi.getEndpointForGetForms(arrayList[i].id);

        ISNetworkManager.get(
            urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if (responseModel.isSuccess()) {
            if (responseModel.payload.containsKey("data") &&
                responseModel.payload["data"] != null) {
              List<dynamic> array = responseModel.payload["data"];
              for (int i = 0; i < array.length; i++) {
                Map<String, dynamic> dict = array[i];
                ISFormDefinitionDataModel form =
                    new ISFormDefinitionDataModel();
                form.deserialize(dict);
                addFormIfNeeded(form);
              }
            }
            //TODO:
            // realm_saveAllForms();
            // ISNotificationWarden.getInstance().notifyTaskObservers();
          } else {
            ISUtilsGeneral.log(responseModel.getBeautifiedErrorMessage());
          }
        });
      }
    }
  }

  requestGetForms(String organizationId, ISNetworkManagerResponse? callback) {
    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      //TODO:
      //realm_requestGetForms(organizationId, callback);
      return;
    }
    String urlString =
        ISUrlManager.locationApi.getEndpointForGetForms(organizationId);
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String, dynamic> dict = array[i];
            ISFormDefinitionDataModel form = new ISFormDefinitionDataModel();
            form.deserialize(dict);
            addFormIfNeeded(form);
          }
        }
        //TODO:
        // realm_saveAllForms();
        // ISNotificationWarden.getInstance().notifyTaskObservers();
      }
      callback!.call(responseModel);
    });
  }

  requestGetFormById(String organizationId, String formId, bool forceLoad,
      ISNetworkManagerResponse? callback) {
    if (!forceLoad) {
      ISFormDefinitionDataModel? formDef = getFormById(formId);
      if (formDef != null) {
        ISNetworkResponseDataModel response =
            ISNetworkResponseDataModel.instanceForSuccess();
        response.parsedObject = formDef;
        callback!.call(response);
        return;
      }
    }

    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      //TODO:
      // realm_requestGetFormById(formId, callback);
      return;
    }
    String urlString = ISUrlManager.locationApi
        .getEndpointForGetFormById(organizationId, formId);
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        ISFormDefinitionDataModel formDef = new ISFormDefinitionDataModel();
        formDef.deserialize(responseModel.payload);
        addFormIfNeeded(formDef);
        responseModel.parsedObject = formDef;
        //TODO:
        // realm_saveAllForms();
        // ISNotificationWarden.getInstance().notifyTaskObservers();
      }
      callback!.call(responseModel);
    });
  }


  requestGetFormSubmissionById(String organizationId, String submissionId,
      ISNetworkManagerResponse callback) {
    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      //TODO:
      // realm_requestGetFormSubmissionById(submissionId, callback);
      return;
    }


    String urlString = ISUrlManager.locationApi
        .getEndpointForGetFormSubmissionById(organizationId, submissionId);

    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        ISFormSubmissionDataModel submission = new ISFormSubmissionDataModel();
        submission.deserialize(responseModel.payload);
        responseModel.parsedObject = submission;
        //TODO:
        //realm_saveFormSubmission(submission);
      }
      callback.call(responseModel);
    });
  }
}
