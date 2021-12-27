import 'package:insurance/isModel/is_utils_general.dart';

class ISUrlManager {
  static UserApi userApi = const UserApi();
  static InviteApi inviteApi = const InviteApi();
  static OrganizationApi organizationApi = const OrganizationApi();
  static EventApi eventApi = const EventApi();
  static ClaimApi claimApi = const ClaimApi();
  static TaskApi taskApi = const TaskApi();
  static ChannelApi channelApi = const ChannelApi();
  static FastFieldFormApi locationApi = const FastFieldFormApi();
}

/// ************* User ****************/
class UserApi {
  const UserApi();

  String getEndpointForUserLogin() {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/login";
  }

  String getEndpointForUserSignup() {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/sign-up";
  }

  String getEndpointForUserUpdate(String userId) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/" + userId;
  }

  String getEndpointForUserForgotPassword() {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/forget-password";
  }

  String getEndpointForUserTokenRefresh(String token) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/refresh/" + token;
  }
}

class InviteApi {
  const InviteApi();

  String getEndpointForGetInvites(String userId) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/" + userId + "/invites";
  }

  String getEndpointForAcceptInvite(String token) {
    return ISUtilsGeneral.getApiBaseUrl() + "/invites/" + token + "/accept";
  }

  String getEndpointForDeclineInvite(String token) {
    return ISUtilsGeneral.getApiBaseUrl() + "/invites/" + token + "/accept";
  }
}

class OrganizationApi {
  const OrganizationApi();

  String getEndpointForGetOrganizations() {
    return ISUtilsGeneral.getApiBaseUrl() + "/organizations";
  }
}

class EventApi {
  const EventApi();

  String getEndpointForGetEvents() {
    return ISUtilsGeneral.getApiBaseUrl() + "/events";
  }
}

class ClaimApi {
  const ClaimApi();

  String getEndpointForGetClaims(String strUserId) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/" + strUserId + "/claims";
  }

  String getEndpointForUpdateClaim(String organizationId, String claimId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/claims/" +
        claimId;
  }

  String getEndpointForUploadMedia(String organizationId, String claimId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/claims/" +
        claimId +
        "/media";
  }

  String getEndpointForMediaWithId(
      String organizationId, String claimId, String mediaId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/claims/" +
        claimId +
        "/media/" +
        mediaId;
  }
}

class TaskApi {
  const TaskApi();

  String getEndpointForGetTasks(String strUserId) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/" + strUserId + "/tasks";
  }

  String getEndpointForConfirmFirstContactTask(
      String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/contact";
  }

  String getEndpointForUpdateTask(String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId;
  }

  String getEndpointForUpdateTaskStatus(
      String organizationId, String taskId, String status) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/" +
        status;
  }

  String getEndpointForUpdateTaskUserLocation(
      String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/current-location";
  }

  String getEndpointForUpdateTaskSchedule(
      String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/schedule";
  }

  String getEndpointForAddNote(String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/notes";
  }

  String getEndpointForAddNoteWithId(
      String organizationId, String taskId, String noteId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/notes/" +
        noteId;
  }

  String getEndpointForUpdateReserves(String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/reserve";
  }

  String getEndpointForUploadTaskMedia(String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/media";
  }

  String getEndpointForGetTaskMedia(
      String organizationId, String taskId, String mediaId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/media/" +
        mediaId;
  }
}

class ChannelApi {
  const ChannelApi();

  String getEndpointForGetChannels(String strUserId) {
    return ISUtilsGeneral.getApiBaseUrl() + "/users/" + strUserId + "/channels";
  }

  String getEndpointForGetChannelMessages(String strUserId,String channelId) {
    return ISUtilsGeneral.getApiBaseUrl() +  "/users/" + strUserId + "/channels/" + channelId;
  }

  String getEndpointForSendChannelMessage(String strUserId,String channelId) {
    return ISUtilsGeneral.getApiBaseUrl() +"/users/" + strUserId +
        "/channels/" +
        channelId +
        "/messages";
  }
}

class FastFieldFormApi {
  const FastFieldFormApi();

  String getEndpointForGetForms(String organizationId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/forms";
  }

  String getEndpointForGetFormById(String organizationId, String formId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/forms/" +
        formId;
  }

  String getEndpointForGetFormSubmissionById(
      String organizationId, String submissionId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/submissions/" +
        submissionId;
  }

  String getEndpointForCreateFormSubmission(
      String organizationId, String taskId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/submissions";
  }

  String getEndpointForUpdateFormSubmission(
      String organizationId, String taskId, String submissionId) {
    return ISUtilsGeneral.getApiBaseUrl() +
        "/organizations/" +
        organizationId +
        "/tasks/" +
        taskId +
        "/submissions/" +
        submissionId;
  }
}
