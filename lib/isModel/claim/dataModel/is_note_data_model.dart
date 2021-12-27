import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_modified_by_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISNoteDataModel {

  String id = "";
  String szComments = "";
  List<ISMediaDataModel> arrayMedia = [];

  DateTime? dateCreatedAt;
  ISModifiedByDataModel modelModifiedBy = ISModifiedByDataModel();

  ISNoteDataModel() {
    initialize();
  }

  initialize() {
    this.id = "";
    this.szComments = "";
    this.arrayMedia = [];
    this.dateCreatedAt = null;
    this.modelModifiedBy = ISModifiedByDataModel();
  }

  Map<String, dynamic>? serializeForCreate() {
    final Map<String, dynamic> params = {};
    if (szComments.isNotEmpty) {
      params["comments"] = szComments;
    }
    if (arrayMedia.length > 0) {
      List<dynamic> array = [];
      for (ISMediaDataModel medium in arrayMedia) {
        Map<String, dynamic> dict = medium.serializeForCreate();
        array.add(dict);
      }
      params["media"] = array;
    }
    return params;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("comments")) {
      szComments = ISUtilsString.refineString(dictionary["comments"]);
    }
    if (dictionary.containsKey("media") && dictionary["media"] != null) {
      List<dynamic> media = dictionary["media"];
      for (int i = 0; i < media.length; i++) {
        Map<String, dynamic> dict = media[i];
        ISMediaDataModel medium = ISMediaDataModel();
        medium.deserialize(dict);
        if (medium.isValid()) arrayMedia.add(medium);
      }
    }
    dateCreatedAt = ISUtilsDate.getDateTimeFromMongoObjectId(id);
    if (dictionary.containsKey("lastModifiedBy") &&
        dictionary["lastModifiedBy"] != null) {
      Map<String, dynamic> dict = dictionary["lastModifiedBy"];
      modelModifiedBy.deserialize(dict);
    }
  }

  Map<String, dynamic>? serializeForUpdate() {
    final Map<String, dynamic> params = {};
    params["id"] = id;
    if (szComments.isNotEmpty) {
      params["comments"] = szComments;
    }
    if (arrayMedia.length > 0) {
      List<dynamic> array = [];
      for (ISMediaDataModel medium in arrayMedia) {
        Map<String, dynamic> dict = medium.serializeForCreate();
        array.add(dict);
      }
      params["media"] = array;
    }

    return params;
  }

  bool isValid() {
    return id.isNotEmpty;
  }
}
