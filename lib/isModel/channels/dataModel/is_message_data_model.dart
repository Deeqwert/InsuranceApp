import 'package:insurance/isModel/channels/dataModel/is_channel_user_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISMessageDataModel {
  String id = "";
  String channelId = "";
  String szMessage = "";
  ISChannelUserDataModel modelCreateBy = ISChannelUserDataModel();
  DateTime? dateCreateAt;
  DateTime? dateUpdateAt;

  ISMessageDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    channelId = "";
    modelCreateBy = ISChannelUserDataModel();
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
      if (dictionary.containsKey("channelId")) {
        channelId = ISUtilsString.refineString(dictionary["channelId"]);
      }
      if (dictionary.containsKey("message")) {
        szMessage = ISUtilsString.refineString(dictionary["message"]);
      }
      if (dictionary.containsKey("createdBy") &&
          dictionary["createdBy"] != null) {
        modelCreateBy.deserialize(dictionary["createdBy"]);
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
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  bool isValid() {
    return (id.isNotEmpty);
  }

  bool amISender() {
    ISUserDataModel? currentUser = ISUserManager.sharedInstance.currentUser;
    if (currentUser == null) return false;
    return (modelCreateBy.userId == currentUser.id);
  }
}
