import 'package:insurance/isModel/channels/dataModel/is_channel_user_data_model.dart';
import 'package:insurance/isModel/channels/dataModel/is_message_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISChannelDataModel {
  String id = "";
  String organizationId = "";
  String szName = "";
  ISEnumChannelStatus enumStatus = ISEnumChannelStatus.active;
  List<ISChannelUserDataModel> arrayUsers = [];
  ISChannelUserDataModel modelCreatedBy = ISChannelUserDataModel();
  List<ISMessageDataModel> arrayMessages = [];

  DateTime? dateCreateAt;
  DateTime? dateUpdateAt;

  ISChannelDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    szName = "";
    enumStatus = ISEnumChannelStatus.active;
    arrayUsers = [];
    modelCreatedBy = new ISChannelUserDataModel();
    arrayMessages = [];
    dateCreateAt = null;
    dateUpdateAt = null;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("id")) {
        id = ISUtilsString.refineString(dictionary["id"]);
      }
      if (dictionary.containsKey("organizationId")) {
        organizationId =
            ISUtilsString.refineString(dictionary["organizationId"]);
      }
      if (dictionary.containsKey("name")) {
        szName = ISUtilsString.refineString(dictionary["name"]);
      }

      if (dictionary.containsKey("createdAt")) {
        dateCreateAt = ISUtilsDate.getDateTimeFromStringWithFormat(
            ISUtilsString.refineString(dictionary["createdAt"]),
            ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
            true);
      }
      if (dictionary.containsKey("updatedAt")) {
        dateCreateAt = ISUtilsDate.getDateTimeFromStringWithFormat(
            ISUtilsString.refineString(dictionary["updatedAt"]),
            ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
            true);
      }

      if (dictionary.containsKey("createdBy") &&
          dictionary["createdBy"] != null) {
        modelCreatedBy.deserialize(dictionary["createdBy"]);
      }

      if (dictionary.containsKey("users") && dictionary["users"] != null) {
        List<dynamic> users = dictionary["users"];
        for (int i = 0; i < users.length; i++) {
          Map<String, dynamic> dict = users[i];
          ISChannelUserDataModel user = ISChannelUserDataModel();
          user.deserialize(dict);
          arrayUsers.add(user);
        }
      }
      if (dictionary.containsKey("status")) {
        this.enumStatus = ChannelStatusExtension.fromString(
            ISUtilsString.refineString(dictionary["status"]));
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  bool isValid() {
    ISUserDataModel? currentUser = ISUserManager.sharedInstance.currentUser;
    if (currentUser == null) return false;
    bool found = false;
    for (ISChannelUserDataModel user in arrayUsers) {
      if (user.userId == currentUser.id) {
        found = true;
        break;
      }
    }
    return id.isNotEmpty && found;
  }

  addMessageIfNeeded(ISMessageDataModel newMessage) {
    if (!newMessage.isValid()) return;
    for (ISMessageDataModel message in arrayMessages) {
      if (message.id == newMessage.id) {
        return;
      }
    }
    arrayMessages.add(newMessage);
  }
}

enum ISEnumChannelStatus { active, archived }

extension ChannelStatusExtension on ISEnumChannelStatus {
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
