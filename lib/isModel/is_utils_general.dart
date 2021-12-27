import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class ISUtilsGeneral {
  static ISEnumAppEnvironment enumEnvironment = ISEnumAppEnvironment.SANDBOX;

  static void log(String text) {
    print("[Insurance]: $text");
  }

  static void forceCrash() {
    throw new Exception("This is a force-crash");
  }

  static String generateRandomString(int length) {
    String letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJK";
    final Random random = new Random();
    var sb = new StringBuffer(length);
    for (int i = 0; i < length; ++i) {
      sb.write(letters.codeUnitAt(random.nextInt(letters.length)));
    }
    return sb.toString();
  }

  static String createRandomScreenshotName(int string) {
    String randomScreenshotName = "screenshot";
    var stringBuilder = new StringBuffer(string);
    Random random = new Random();
    int i = 0;
    while (i < string) {
      stringBuilder.write(randomScreenshotName
          .codeUnitAt(random.nextInt(randomScreenshotName.length)));
    }
    return stringBuilder.toString();
  }

  static String getApiBaseUrl() {
    if (ISUtilsGeneral.enumEnvironment == ISEnumAppEnvironment.SANDBOX) {
      return " your base url here";
    } else if (ISUtilsGeneral.enumEnvironment == ISEnumAppEnvironment.STAGING) {
      return " your base url here";
    } else if (ISUtilsGeneral.enumEnvironment ==
        ISEnumAppEnvironment.PRODUCTION) {
      return " your base url here";
    }
    return " your base url here";
  }

  static Future<String> getAppVersionString() async {
    final info = await PackageInfo.fromPlatform();
    var appVersion = info.version;
    return appVersion;
  }

  static Future<String> getAppBuildString() async {
    final info = await PackageInfo.fromPlatform();
    var appVersion = info.buildNumber;
    return appVersion;
  }

  static Future<String> getBeautifiedAppVersionInfo() async {
    if (ISUtilsGeneral.enumEnvironment == ISEnumAppEnvironment.SANDBOX) {
      return "Version " +
          await getAppVersionString() +
          " - " +
          await getAppBuildString() +
          " - DEV";
    } else if (ISUtilsGeneral.enumEnvironment == ISEnumAppEnvironment.STAGING) {
      return "Version " + await getAppVersionString() + " - QA";
    } else if (ISUtilsGeneral.enumEnvironment ==
        ISEnumAppEnvironment.PRODUCTION) {
      return "Version " + await getAppVersionString();
    } else {
      return "Version " + await getAppVersionString() + " - DEV";
    }
  }

  Future<String> getExternalFilePath() async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path + '/insurance'}');
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static final String formListUpdated = "Insurance.Form.ListUpdated";
  static final String claimListUpdated = "Insurance.Claim.ListUpdated";
  static final String formRequestReloaded = "Insurance.Form.RequestReloaded";
  static final String messageListUpdated = "Insurance.message.ListUpdated";
  static final String channelListUpdated = "Insurance.channel.ListUpdated";

}

enum ISEnumAppEnvironment { SANDBOX, STAGING, PRODUCTION }

extension AppEnviromentExtension on ISEnumAppEnvironment {
  static ISEnumAppEnvironment fromString(int? status) {
    if (status == null) {
      return ISEnumAppEnvironment.SANDBOX;
    }
    for (ISEnumAppEnvironment t in ISEnumAppEnvironment.values) {
      if (status == t.value) return t;
    }
    return ISEnumAppEnvironment.SANDBOX;
  }

  int get value {
    switch (this) {
      case ISEnumAppEnvironment.SANDBOX:
        return -1;
      case ISEnumAppEnvironment.PRODUCTION:
        return 0;
      default:
        return 0;
    }
  }
}

enum ISEnumChannelStatus { active, archived }

extension ISEnumChannelExtension on ISEnumChannelStatus {
  static ISEnumChannelStatus fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumChannelStatus.active;
    }
    for (ISEnumChannelStatus t in ISEnumChannelStatus.values) {
      if (status == t.value) return t;
    }
    return ISEnumChannelStatus.archived;
  }

  String get value {
    switch (this) {
      case ISEnumChannelStatus.active:
        return "Active";
      case ISEnumChannelStatus.archived:
        return "Archived";
    }
  }
}

enum ISEnumUserStatus { active, delete }

extension ISEnumUserStatusExtension on ISEnumUserStatus {
  static ISEnumUserStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumUserStatus.active;
    }
    if (str.toLowerCase() == ISEnumUserStatus.active.toString().toLowerCase()) {
      return ISEnumUserStatus.active;
    } else if (str.toLowerCase() ==
        ISEnumUserStatus.delete.toString().toLowerCase()) {
      return ISEnumUserStatus.delete;
    }
    return ISEnumUserStatus.active;
  }

  String get value {
    switch (this) {
      case ISEnumUserStatus.active:
        return "Active";
      case ISEnumUserStatus.delete:
        return "Deleted";
    }
  }
}

enum ISEnumInvitationStatus { pending, accepted, declined }

extension ISEnumInvitationExtension on ISEnumInvitationStatus {
  static ISEnumInvitationStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumInvitationStatus.pending;
    }
    if (str.toLowerCase() ==
        ISEnumInvitationStatus.pending.toString().toLowerCase()) {
      return ISEnumInvitationStatus.pending;
    } else if (str.toLowerCase() ==
        ISEnumInvitationStatus.accepted.toString().toLowerCase()) {
      return ISEnumInvitationStatus.accepted;
    } else if (str.toLowerCase() ==
        ISEnumInvitationStatus.declined.toString().toLowerCase()) {
      return ISEnumInvitationStatus.declined;
    }
    return ISEnumInvitationStatus.pending;
  }

  String get value {
    switch (this) {
      case ISEnumInvitationStatus.pending:
        return "Pending";
      case ISEnumInvitationStatus.accepted:
        return "Accepted";
      case ISEnumInvitationStatus.declined:
        return "Declined";
    }
  }
}

enum ISEnumOrganizationUserRole {
  admin,
  adjusterAdmin,
  adjuster,
  agent,
  claimManager
}

extension ISEnumOrganizationExtension on ISEnumOrganizationUserRole {
  static ISEnumOrganizationUserRole fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumOrganizationUserRole.adjuster;
    }
    if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.admin.toString().toLowerCase()) {
      return ISEnumOrganizationUserRole.admin;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.adjusterAdmin.toString().toLowerCase()) {
      return ISEnumOrganizationUserRole.adjusterAdmin;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.adjuster.toString().toLowerCase()) {
      return ISEnumOrganizationUserRole.adjuster;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.agent.toString().toLowerCase()) {
      return ISEnumOrganizationUserRole.agent;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.claimManager.toString().toLowerCase()) {
      return ISEnumOrganizationUserRole.claimManager;
    }
    return ISEnumOrganizationUserRole.adjuster;
  }

  String get value {
    switch (this) {
      case ISEnumOrganizationUserRole.admin:
        return "Administrator";
      case ISEnumOrganizationUserRole.adjusterAdmin:
        return "Adjuster Administrator";
      case ISEnumOrganizationUserRole.adjuster:
        return "Adjuster";
      case ISEnumOrganizationUserRole.agent:
        return "Agent";
      case ISEnumOrganizationUserRole.claimManager:
        return "Claim Manager";
    }
  }
}

enum ISEnumOrganizationuserStatus { active, deleted }

extension ISEnumOrganizationuserExtension on ISEnumOrganizationuserStatus {
  static ISEnumOrganizationuserStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumOrganizationuserStatus.active;
    }
    if (str.toLowerCase() ==
        ISEnumOrganizationuserStatus.active.toString().toLowerCase()) {
      return ISEnumOrganizationuserStatus.active;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationuserStatus.deleted.toString().toLowerCase()) {
      return ISEnumOrganizationuserStatus.deleted;
    }

    return ISEnumOrganizationuserStatus.active;
  }

  String get value {
    switch (this) {
      case ISEnumOrganizationuserStatus.active:
        return "Active";
      case ISEnumOrganizationuserStatus.deleted:
        return "Deleted";
    }
  }
}

enum ISEnumClaimStatus {
  unknown,
  NEW,
  pending,
  scheduled,
  inProgress,
  completed,
  closed,
  deleted,
}

extension ISEnumClaimStatusExptension on ISEnumClaimStatus {
  static ISEnumClaimStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumClaimStatus.unknown;
    }
    if (str.toLowerCase() == ISEnumClaimStatus.NEW.toString().toLowerCase()) {
      return ISEnumClaimStatus.NEW;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.pending.toString().toLowerCase()) {
      return ISEnumClaimStatus.pending;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.scheduled.toString().toLowerCase()) {
      return ISEnumClaimStatus.scheduled;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.inProgress.toString().toLowerCase()) {
      return ISEnumClaimStatus.inProgress;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.completed.toString().toLowerCase()) {
      return ISEnumClaimStatus.completed;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.closed.toString().toLowerCase()) {
      return ISEnumClaimStatus.closed;
    } else if (str.toLowerCase() ==
        ISEnumClaimStatus.deleted.toString().toLowerCase()) {
      return ISEnumClaimStatus.deleted;
    }
    return ISEnumClaimStatus.unknown;
  }

  String get value {
    switch (this) {
      case ISEnumClaimStatus.unknown:
        return "";
      case ISEnumClaimStatus.NEW:
        return "New";
      case ISEnumClaimStatus.pending:
        return "Pending";
      case ISEnumClaimStatus.scheduled:
        return "Scheduled";
      case ISEnumClaimStatus.inProgress:
        return "In Progress";
      case ISEnumClaimStatus.completed:
        return "Completed";
      case ISEnumClaimStatus.closed:
        return "Closed";
      case ISEnumClaimStatus.deleted:
        return "Deleted";
    }
  }
}

enum ISEnumMediaMimeType { png, jpg, pdf }

extension ISEnumMediaMimeTypeExtension on ISEnumMediaMimeType {
  static ISEnumMediaMimeType fromString(String? string) {
    if (string == null || string.isEmpty) return ISEnumMediaMimeType.png;

    if (string.toLowerCase() == ISEnumMediaMimeType.png.value.toLowerCase()) {
      return ISEnumMediaMimeType.png;
    } else if (string.toLowerCase() ==
        ISEnumMediaMimeType.jpg.value.toLowerCase()) {
      return ISEnumMediaMimeType.jpg;
    } else if (string.toLowerCase() ==
        ISEnumMediaMimeType.pdf.value.toLowerCase()) {
      return ISEnumMediaMimeType.pdf;
    }

    return ISEnumMediaMimeType.png;
  }

  String get value {
    switch (this) {
      case ISEnumMediaMimeType.png:
        return "image/png";
      case ISEnumMediaMimeType.jpg:
        return "image/jpg";
      case ISEnumMediaMimeType.pdf:
        return "application/pdf";
    }
  }
}

enum ISEnumEventStatus { active, deleted }

extension ISEnumEventStatusExtension on ISEnumEventStatus {
  String get value {
    switch (this) {
      case ISEnumEventStatus.active:
        return "Active";
      case ISEnumEventStatus.deleted:
        return "Deleted";
    }
  }

  static ISEnumEventStatus fromString(String? string) {
    if (string == null || string.isEmpty) return ISEnumEventStatus.active;
    if (string.toLowerCase() ==
        ISEnumEventStatus.active.toString().toLowerCase()) {
      return ISEnumEventStatus.active;
    } else if (string.toLowerCase() ==
        ISEnumEventStatus.deleted.toString().toLowerCase()) {
      return ISEnumEventStatus.deleted;
    }
    return ISEnumEventStatus.active;
  }
}

enum ISEnumPartnerStatus {
  active,
  deleted,
}

extension ISEnumPartnerStatusExtension on ISEnumPartnerStatus {
  String get value {
    switch (this) {
      case ISEnumPartnerStatus.active:
        return "Active";
      case ISEnumPartnerStatus.deleted:
        return "Deleted";
    }
  }

  static ISEnumPartnerStatus fromString(String? string) {
    if (string == null || string.isEmpty) return ISEnumPartnerStatus.active;
    if (string.toLowerCase() ==
        ISEnumPartnerStatus.active.toString().toLowerCase()) {
      return ISEnumPartnerStatus.active;
    } else if (string.toLowerCase() ==
        ISEnumPartnerStatus.deleted.toString().toLowerCase()) {
      return ISEnumPartnerStatus.deleted;
    }
    return ISEnumPartnerStatus.active;
  }
}

// enum ISEnumTaskSortBy { status, date, type }
//
// extension ISEnumTaskSortByExtension on ISEnumTaskSortBy {
//   int get value {
//     switch (this) {
//       case ISEnumTaskSortBy.status:
//         return 0;
//       case ISEnumTaskSortBy.date:
//         return 1;
//       case ISEnumTaskSortBy.type:
//         return 2;
//     }
//   }
// }

enum ISTaskFilterPopupFor { map, claimList, claimHistory }

extension ISTaskFilterPopupForExtension on ISTaskFilterPopupFor {
  int get value {
    switch (this) {
      case ISTaskFilterPopupFor.map:
        return 0;
      case ISTaskFilterPopupFor.claimList:
        return 1;
      case ISTaskFilterPopupFor.claimHistory:
        return 2;
    }
  }
}

enum ISEnumNetworkRequestMethodType {
  none,
  get,
  post,
  put,
  delete,
  upload,
  download
}

extension ISEnumNetworkRequestMethodTypeExtension
    on ISEnumNetworkRequestMethodType {
  int get value {
    switch (this) {
      case ISEnumNetworkRequestMethodType.none:
        return 0;
      case ISEnumNetworkRequestMethodType.get:
        return 1;
      case ISEnumNetworkRequestMethodType.post:
        return 2;
      case ISEnumNetworkRequestMethodType.put:
        return 3;
      case ISEnumNetworkRequestMethodType.delete:
        return 4;
      case ISEnumNetworkRequestMethodType.upload:
        return 5;
      case ISEnumNetworkRequestMethodType.download:
        return 6;
    }
  }

  static ISEnumNetworkRequestMethodType fromInt(int value) {
    for (int i = 0; i < ISEnumNetworkRequestMethodType.values.length; i++) {
      ISEnumNetworkRequestMethodType methodType =
          ISEnumNetworkRequestMethodType.values[i];
      if (methodType.value == value) {
        return methodType;
      }
    }
    return ISEnumNetworkRequestMethodType.none;
  }
}

enum ISEnumOfflineRequestStatus { New, inProgress, completed, failed }

extension ISEnumOfflineRequestStatusExtension on ISEnumOfflineRequestStatus {
  static ISEnumOfflineRequestStatus fromInt(int value) {
    for (int i = 0; i < ISEnumOfflineRequestStatus.values.length; i++) {
      ISEnumOfflineRequestStatus methodType =
          ISEnumOfflineRequestStatus.values[i];
      if (methodType.value == value) {
        return methodType;
      }
    }
    return ISEnumOfflineRequestStatus.New;
  }

  int get value {
    switch (this) {
      case ISEnumOfflineRequestStatus.New:
        return 0;
      case ISEnumOfflineRequestStatus.inProgress:
        return 1;
      case ISEnumOfflineRequestStatus.completed:
        return 2;
      case ISEnumOfflineRequestStatus.failed:
        return 3;
    }
  }
}

enum ISEnumOfflineSyncStatus { ready, inProgress }

extension ISEnumOfflineSyncStatusExtension on ISEnumOfflineSyncStatus {
  int get value {
    switch (this) {
      case ISEnumOfflineSyncStatus.ready:
        return 0;
      case ISEnumOfflineSyncStatus.inProgress:
        return 1;
    }
  }
}
