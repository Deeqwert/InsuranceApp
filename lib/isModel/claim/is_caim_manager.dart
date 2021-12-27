import 'dart:io';
import 'dart:math';

import 'package:insurance/isModel/LocationManager.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_filter_option_data_model.dart';
import 'package:insurance/isModel/communications/is_network_manager.dart';
import 'package:insurance/isModel/communications/is_network_manager_response.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/communications/is_network_response_data_model.dart';
import 'package:insurance/isModel/communications/is_offline_request_manager.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISClaimManager {
  static ISClaimManager sharedInstance = ISClaimManager();
  List<ISTaskDataModel> arrayTasks = [];
  ISTaskFilterOptionDataModel modelFilter = ISTaskFilterOptionDataModel();

  ISClaimManager() {
    initialize();
  }

  initialize() {
    arrayTasks = [];
    modelFilter = ISTaskFilterOptionDataModel();
  }

  addTaskIfNeeded(ISTaskDataModel newTask) {
    if (!newTask.isValid()) return;

    for (int i = 0; i < arrayTasks.length; i++) {
      ISTaskDataModel task = arrayTasks[i];
      if (task.id == newTask.id) {
        arrayTasks.replaceRange(i, i + 1, [newTask]);
        task.invalidate();
        return;
      }
    }
    arrayTasks.add(newTask);
  }

  ISTaskDataModel? getTaskById(String taskId) {
    for (var task in arrayTasks) {
      if (task.id == taskId) return task;
    }
    return null;
  }

  invalidateAllTasks() {
    for (var task in arrayTasks) {
      task.invalidate();
    }

    arrayTasks = [];
  }

  List<ISTaskDataModel> getTasksByStatus(List<ISEnumTaskStatus> arrayStatus) {
    List<ISTaskDataModel> array = [];

    for (var task in arrayTasks) {
      bool found = false;
      for (var status in arrayStatus) {
        if (task.enumStatus == status) {
          found = true;
          break;
        }
      }
      if (found) {
        array.add(task);
      }
    }

    return array;
  }

  List<ISTaskDataModel> filterTaskFrom(
      List<ISTaskDataModel>? tasks, List<ISEnumTaskStatus> statuses) {
    List<ISTaskDataModel> arrayFilterFrom = [];
    List<ISTaskDataModel> arrayResult = [];

    for (var task in arrayTasks) {
      arrayFilterFrom.add(task);
    }

    if (tasks != null) {
      arrayFilterFrom.clear();
      for (var task in tasks) {
        arrayFilterFrom.add(task);
      }
    }

    for (var task in arrayFilterFrom) {
      bool found = false;
      for (var status in statuses) {
        if (task.enumStatus == status) {
          found = true;
          break;
        }
      }
      if (found) {
        arrayResult.add(task);
      }
    }

    return arrayResult;
  }

  List<ISTaskDataModel> getTaskByFilterOptions(
      ISTaskFilterOptionDataModel? filter) {
    if (filter == null) {
      List<ISTaskDataModel> array = List.from(arrayTasks);
      return array;
    }

    List<ISTaskDataModel> array = [];

    for (var task in arrayTasks) {
      var claim = task.getClaimDataModel();

      // Claim Number
      if (filter.szClaimNumber.isNotEmpty) {
        String claimNumber = filter.szClaimNumber.toLowerCase();
        if (claim != null) {
          if (!claim.szClaimNumber.toLowerCase().contains(claimNumber)) {
            continue;
          }
        }
      }
      //Orgnazation
      if (filter.organizationId != null) {
        if (claim != null) {
          if (claim.organizationId != filter.organizationId) continue;
        }
      }
      //Status
      if (filter.enumStatus != ISEnumTaskStatus.none &&
          filter.enumStatus != task.enumStatus) {
        continue;
      }
      //Date
      if (filter.date != null) {
        if (task.dateScheduledStart == null) continue;
        if (!ISUtilsDate.isSameDate(filter.date, task.dateScheduledStart))
          continue;
      }
      //Type
      if (filter.enumType != ISEnumClaimType.none) {
        if (claim != null) {
          bool found = false;
          for (var type in claim.arrayTypes) {
            if (type == filter.enumType) {
              found = true;
              break;
            }
          }

          if (!found) continue;
        } else {
          continue;
        }
      }
      array.add(task);
    }

    // Sort
    if (filter.enumSortBy == ISEnumTaskSortBy.date) {
      array.sort((s1, s2) {
        DateTime? date1 = s1.dateScheduledStart;
        DateTime? date2 = s2.dateScheduledStart;
        if (date1 == null && date2 == null) return 0;
        if (date1 == null) return 1;
        if (date2 == null) return -1;
        return date2.compareTo(date1);
      });
    } else if (filter.enumSortBy == ISEnumTaskSortBy.status) {
      array.sort((s1, s2) {
        return (s1.enumStatus.toInt() - s2.enumStatus.toInt());
      });
    } else if (filter.enumSortBy == ISEnumTaskSortBy.type) {
      array.sort((s1, s2) {
        var claim1 = s1.getClaimDataModel();
        var claim2 = s1.getClaimDataModel();
        if (claim1 == null) return 1;
        if (claim2 == null) return -1;

        int min0 = double.maxFinite.toInt(), min1 = double.maxFinite.toInt();
        for (var type in claim1.arrayTypes) {
          min0 = min(min0, type.toInt());
        }
        for (var type in claim2.arrayTypes) {
          min1 = min(min1, type.toInt());
        }
        return min0 - min1;
      });
    }

    return array;
  }



  updateLocationForEnRouteTasks() {
    LCLocationManager locationManager =LCLocationManager();
    if(locationManager.lat == 0.0 || locationManager.lng == 0.0) return;
    List<ISEnumTaskStatus> arrayStatus = [
      ISEnumTaskStatus.enRoute,
      ISEnumTaskStatus.arrived,
      ISEnumTaskStatus.departed,
    ];
     List<ISTaskDataModel> tasks = getTasksByStatus(arrayStatus);

    for(ISTaskDataModel task in tasks) {
      requestUpdateLocationForTask(task, locationManager.lat,locationManager.lng ,(responseDataModel) {
        if (responseDataModel.isSuccess()) {
        } else {
        }
      });
    }
  }

  requestGetTasks(ISNetworkManagerResponse? callback) {
    if (!ISUserManager.sharedInstance.isLoggedIn()) {
      ISNetworkResponseDataModel responseDataModel =
          ISNetworkResponseDataModel();
      responseDataModel.code = EnumNetworkResponseCode.code400BadRequest.value;
      if (callback != null) callback.call(responseDataModel);
      return;
    }
    //TODO:
    // if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //
    //   // realm_requestGetTasks(callback);
    //   return;
    // }
    String urlString = ISUrlManager.taskApi
        .getEndpointForGetTasks(ISUserManager.sharedInstance.currentUser!.id);
    ISNetworkManager.get(
        urlString, {}, ISEnumNetworkAuthOptions.authRequired.value,
        (responseModel) {
      if (responseModel.isSuccess()) {
        invalidateAllTasks();

        if (responseModel.payload.containsKey("data") &&
            responseModel.payload["data"] != null) {
          List<dynamic> array = responseModel.payload["data"];
          for (int i = 0; i < array.length; i++) {
            Map<String,dynamic> dict = array[i];
            ISTaskDataModel task = ISTaskDataModel();
            task.deserialize(dict);
            addTaskIfNeeded(task);
          }
          //TODO:
          // realm_replaceAllTasks();
           ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.claimListUpdated);
        }
      }
      callback?.call(responseModel);
    });
  }

  requestUploadPhotoForTask(ISTaskDataModel task, File file, ISNetworkManagerResponse? callback) {

    ISClaimDataModel? claim = task.getClaimDataModel();

    if (claim!.organizationId=="" || claim.id=="" ||task.id=="") {
      ISNetworkResponseDataModel responseDataModel =  ISNetworkResponseDataModel();
      responseDataModel.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(responseDataModel);
      return;
    }
    String organizationId = claim.organizationId;

    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }
    String urlString = ISUrlManager.claimApi.getEndpointForUploadMedia(organizationId, claim.id);

    //TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //   ISMediaDataModel media =  ISMediaDataModel();
    //   media.id = ISUtilsString.generateRandomString(16);
    //   media.mediaId = media.id;
    //   media.organizationId = organizationId;
    //   media.claimId = claim.id;
    //   media.enumMimeType = EnumMediaMimeType.png;
    //   media.szFileName = "file.png";
    //   media.szEncoding = "";
    //   media.nSize = 0;
    //   media.szNote = "";
    //
    //
    //   // if(OfflineManager.sharedInstance().saveImageToDisk(file, media.id, ISUtilsGeneral.ISEnumMediaMimeType.PNG)) {
    //   //   urlString = ISUrlManager.getEndpointForMediaWithId(organizationId, claim.id, media.id);
    //   //   OfflineRequestDataModel request =  OfflineRequestDataModel();
    //   //   request.id = media.id;
    //   //   request.enumMethod = ISEnumNetworkRequestMethodType.upload;
    //   //   request.szUrlString = urlString;
    //   //   request.dictParams = {};
    //   //   request.enumStatus = ISEnumOfflineRequestStatus.New;
    //   //   request.nAuthOption = ISEnumNetworkAuthOptions.authRequired.value;
    //   //
    //   //   ISOfflineRequestManager.sharedInstance.enqueueRequest(request);
    //   //   ISNetworkResponseDataModel response = ISNetworkResponseDataModel.instanceForSuccess();
    //   //   response.parsedObject = media;
    //   //   callback!.call(response);
    //   // } else {
    //   //   callback!.call(ISNetworkResponseDataModel.instanceForFailure());
    //   // }
    //   return;
    // }

    ISNetworkManager.upload(
        urlString, "file",file,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            ISMediaDataModel medium =ISMediaDataModel();
            medium.deserialize(responseModel.payload);
            responseModel.parsedObject = medium;
          }else{
          }
          callback?.call(responseModel);
        });

  }

  requestAddNoteForClaim(ISClaimDataModel claim, ISNoteDataModel newNote, ISNetworkManagerResponse? callback) {
    String urlString = ISUrlManager.claimApi.getEndpointForUpdateClaim(claim.organizationId, claim.id);
    List<dynamic> notes = claim.serializeNotes();
    notes.add(newNote.serializeForCreate());
    Map<String,dynamic> params={};
    params["notes"]=notes;
    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            claim.deserializeNotes(responseModel.payload);
            ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.claimListUpdated);
          }else{
          }
          callback?.call(responseModel);
        });
  }

  //Tasks
  requestConfirmFirstContact(ISTaskDataModel task, DateTime datetime, ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if(claim == null) {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }
    if(claim.organizationId=="" || claim.id=="" || task.id=="") {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }
    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForConfirmFirstContactTask(organizationId, task.id);
    Map<String,dynamic> params={};
    params["firstContactDate"]=ISUtilsDate.getStringFromDateTimeWithFormat(datetime,ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,true);

    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            task.dateFirstContact = datetime;
            //TODO;
            // realm_saveTask(task);
          }else{
          }
          callback?.call(responseModel);
        });
  }

  requestDeclineTask(ISTaskDataModel task, String reason,ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if(claim == null) {
      ISNetworkResponseDataModel response =  ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    if(claim.organizationId=="" || claim.id=="" || task.id=="") {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForUpdateTaskStatus(organizationId, task.id,ISEnumTaskStatus.declined.toStringForUpdateEndpoint());
    Map<String,dynamic> params={};
    params["declineReason"]= reason;

    // TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //
    //   // OfflineRequestDataModel request =  OfflineRequestDataModel();
    //   // request.enumMethod = ISEnumNetworkRequestMethodType.put;
    //   // request.szUrlString = urlString;
    //   // request.dictParams = params;
    //   // request.enumStatus = ISEnumOfflineRequestStatus.New;
    //   // request.nAuthOption = ISEnumNetworkAuthOptions.authRequired.value;
    //   // ISOfflineRequestManager.sharedInstance.enqueueRequest(request);
    //   // task.enumStatus = ISEnumTaskStatus.declined;
    //   // this.realm_saveTask(task);
    //   callback!.call(ISNetworkResponseDataModel.instanceForSuccess());
    //   return;
    // }

    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            requestGetTasks(callback);
          }else{
          }
          callback?.call(responseModel);
        });
  }

  requestUpdateTaskStatus(ISTaskDataModel task,ISEnumTaskStatus newStatus,ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if(claim == null) {
      ISNetworkResponseDataModel response =  ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    if(claim.organizationId=="" ||  claim.id=="" || task.id=="") {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForUpdateTaskStatus(organizationId, task.id, newStatus.toStringForUpdateEndpoint());
    //   //TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //   OfflineRequestDataModel request =  OfflineRequestDataModel();
    //   Map<String,dynamic> params={};
    //   params["offline"]= true;
    //   if(newStatus==ISEnumTaskStatus.arrived){
    //     params["actualStartDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    //   }
    //   if(newStatus==ISEnumTaskStatus.departed){
    //     params["actualEndDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    //   }
    //   if(newStatus==ISEnumTaskStatus.completed){
    //     params["completedDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    //   }
    // request.enumMethod = ISEnumNetworkRequestMethodType.put;
    // request.szUrlString = urlString;
    // request.dictParams = params;
    // request.enumStatus =ISEnumOfflineRequestStatus.New;
    // request.nAuthOption = ISEnumNetworkAuthOptions.authRequired.value;
    // ISOfflineRequestManager.sharedInstance.enqueueRequest(request);
    // task.enumStatus = newStatus;
    // realm_saveTask(task);
    // callback!.call(ISNetworkResponseDataModel.instanceForSuccess());
    // return;
    // }



    Map<String,dynamic> params={};
    params["offline"]= true;
    if(newStatus==ISEnumTaskStatus.arrived){
      params["actualStartDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    }
    if(newStatus==ISEnumTaskStatus.departed){
      params["actualEndDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    }
    if(newStatus==ISEnumTaskStatus.completed){
      params["completedDate"]= ISUtilsDate.getStringFromDateTimeWithFormat(DateTime.now(),ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value, true);
    }


    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            task.enumStatus = newStatus;
            ISUtilsGeneral.log("Status:"+task.enumStatus.value);
            //TODO:
            // realm_saveTask(task);
          }else{
          }
          callback?.call(responseModel);
        });
  }

  requestScheduleTask(ISTaskDataModel task, DateTime dateStart, DateTime dateEnd, ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if(claim == null) {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    if(claim.organizationId.isEmpty ||claim.id.isEmpty || task.id.isEmpty) {
      ISNetworkResponseDataModel response =  ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForUpdateTaskSchedule(organizationId, task.id);
    Map<String,dynamic>params={};
    params["scheduleStartDate"]=ISUtilsDate.getStringFromDateTimeWithFormat(dateStart,ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,true);
    params["scheduleEndDate"]=ISUtilsDate.getStringFromDateTimeWithFormat(dateEnd,ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,true);

    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            task.enumStatus = ISEnumTaskStatus.scheduled;
            task.dateScheduledStart = dateStart;
            task.dateScheduledEnd = dateEnd;
            //TODO:
            // realm_saveTask(task);
          }else{
          }
          callback?.call(responseModel);
        });
  }

  requestUpdateLocationForTask(ISTaskDataModel task, double latitude, double longitude, ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if(claim == null) {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    if(claim.organizationId=="" ||claim.id=="" ||
       task.id=="") {
      ISNetworkResponseDataModel response =  ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForUpdateTaskUserLocation(organizationId, task.id);
    Map<String,dynamic> params={};
    List<dynamic> arr=[];
    arr.add(longitude);
    arr.add(latitude);
    Map<String,dynamic> obj={};
    obj["type"]="Point";
    obj["coordinates"]=arr;
    params["currentLocation"]=obj;

    ISNetworkManager.put(
        urlString, params,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
          }else{
          }
          callback?.call(responseModel);
        });
  }


  requestUpdateSubmissionForTask(ISTaskDataModel task, ISNetworkManagerResponse? callback) {
    if(task.getClaimDataModel() == null) {
      callback!.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }

    ISClaimDataModel claim = task.getClaimDataModel()!;
    if(claim.organizationId.isEmpty|| claim.id.isEmpty || task.id.isEmpty) {
      callback!.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }

    String urlString = ISUrlManager.taskApi.getEndpointForUpdateTask(organizationId, task.id);
    Map<String,dynamic> params = task.serializeForFormSubmissions();

    //TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //   // OfflineRequestDataModel request = OfflineRequestDataModel();
    //   // request.enumMethod = ISUtilsGeneral.ISEnumNetworkRequestMethodType.PUT;
    //   // request.szUrlString = urlString;
    //   // request.dictParams = params;
    //   // request.enumStatus = ISUtilsGeneral.ISEnumOfflineRequestStatus.NEW;
    //   // request.nAuthOption = ISEnumNetworkAuthOptions.AUTH_REQUIRED.getValue();
    //   // OfflineManager.sharedInstance().addRequestToQueue(request);
    //   //
    //   // this.realm_saveTask(task);
    //   callback?.call(ISNetworkResponseDataModel.instanceForSuccess());
    //   return;
    // }
    ISNetworkManager.put(
        urlString, params, ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
          }else{
          }
          //TODO:
          // realm_saveTask(task);
          callback?.call(responseModel);
        });
  }

  //Notes
  requestAddNoteForTask(ISTaskDataModel task, ISNoteDataModel newNote, ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();

    if(claim == null) {
      ISNetworkResponseDataModel response = ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    if(claim.organizationId.isEmpty || claim.id.isEmpty || task.id.isEmpty) {
      ISNetworkResponseDataModel response =  ISNetworkResponseDataModel();
      response.code = EnumNetworkResponseCode.code400BadRequest.value;
      callback!.call(response);
      return;
    }

    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }
    String urlString = ISUrlManager.taskApi.getEndpointForAddNote(organizationId, task.id);
    Map<String,dynamic> params =newNote.serializeForCreate()!;
     //TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //   urlString = ISUrlManager.taskApi.getEndpointForAddNoteWithId(organizationId, task.id, "IS"+DateTime.now().toString());

      // OfflineRequestDataModel request =  OfflineRequestDataModel();
      // urlString = ISUrlManager.taskApi.getEndpointForAddNoteWithId(organizationId, task.id, request.id);
      // request.enumMethod =ISEnumNetworkRequestMethodType.post;
      // request.szUrlString = urlString;
      // request.dictParams = params;
      // request.enumStatus = ISEnumOfflineRequestStatus.New;
      // request.nAuthOption = ISEnumNetworkAuthOptions.authRequired.value;
      // ISOfflineRequestManager.sharedInstance.enqueueRequest(request);
      // newNote.id = request.id;
      // newNote.dateCreatedAt = DateTime.now();
      // task.addNoteIfNeeded(newNote);
      // realm_saveTask(task);
    //   ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.claimListUpdated);
    //   callback?.call(ISNetworkResponseDataModel.instanceForSuccess());
    //   return;
    // }
    ISNetworkManager.post(
        urlString, params, ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
            ISTaskDataModel updatedTask = ISTaskDataModel();
            updatedTask.deserialize(responseModel.payload);
            addTaskIfNeeded(updatedTask);
            //TODO:
            // realm_saveTask(updatedTask);
            ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.claimListUpdated);
          }
          callback?.call(responseModel);
        });
  }

  // Reserves
  requestUpdateReservesForTask(ISTaskDataModel task, ISNetworkManagerResponse? callback) {
    ISClaimDataModel? claim = task.getClaimDataModel();
    if (claim == null) {
      callback?.call(ISNetworkResponseDataModel.instanceForFailure());
      return;
    }
    if (claim.organizationId.isEmpty || claim.organizationId.isEmpty ||
        claim.id.isEmpty ||
        task.id.isEmpty) {
      callback?.call(ISNetworkResponseDataModel.instanceForFailure());
          return;
    }
    String organizationId = claim.organizationId;
    if(task.modelOrganization.id.isNotEmpty) {
      organizationId = task.modelOrganization.id;
    }
    String url = ISUrlManager.taskApi.getEndpointForUpdateReserves(organizationId, task.id);
    Map<String,dynamic> params=task.serializeForReserves();
    //TODO:
    // if(ISNetworkReachabilityManager.sharedInstance.bOfflineFirst ||
    //     !ISNetworkReachabilityManager.sharedInstance.isConnected()) {
    //     params["offline"]=true;

        // ISOfflineRequestDataModel request =  ISOfflineRequestDataModel();
        // request.enumMethod = ISUtilsGeneral.ISEnumNetworkRequestMethodType.PUT;
        // request.szUrlString = url;
        // request.dictParams = params;
        // request.enumStatus = ISUtilsGeneral.ISEnumOfflineRequestStatus.NEW;
        // request.nAuthOption = ISEnumNetworkAuthOptions.AUTH_REQUIRED.getValue();
        // OfflineManager.sharedInstance().addRequestToQueue(request);
        //
        // realm_saveTask(task);
    //     callback?.call(ISNetworkResponseDataModel.instanceForSuccess());
    // }

    ISNetworkManager.put(
        url, params, ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
             if(responseModel.isSuccess()){
             }else{
             }
               //TODO:
              // realm_saveTask(task);
          callback?.call(responseModel);
        });
  }

  //Download
  requestDownloadForMedia(ISMediaDataModel media, String downloadPath, ISNetworkManagerResponse? callback) {
    String urlString = media.getUrlString();
    ISNetworkManager.download(urlString,media.enumMimeType.value,downloadPath,ISEnumNetworkAuthOptions.authRequired.value,
            (responseModel) {
          if(responseModel.isSuccess()){
          }else{
          }
          callback?.call(responseModel);
        });
  }
}
