import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';

class ISMediaDataModel {
  String id = "";
  String organizationId = "";
  String claimId = "";
  String mediaId = "";
  EnumMediaMimeType enumMimeType = EnumMediaMimeType.png;
  String szFileName = "";
  String szOriginalName = "";
  String szEncoding = "";
  int nSize = 0;
  String szDownloadedUrl = "";
  String szNote = "";

  // extra property. used for different purposes, same as tag of UIButton
  int tag = 0;

  ISMediaDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    organizationId = "";
    claimId = "";
    mediaId = "";
    enumMimeType = EnumMediaMimeType.png;
    szFileName = "";
    szEncoding = "";
    szOriginalName = "";
    nSize = 0;
    szDownloadedUrl = "";
    szNote = "";

    tag = 0;
  }

  Map<String, dynamic> serializeForCreate() {
    return {
      "organizationId": organizationId,
      "claimId": claimId,
      "mediaId": id,
      "mimeType": enumMimeType.value,
      "fileName": szFileName,
      "encoding": szEncoding,
      "size": nSize,
      "note": szNote
    };
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("organizationId")) {
      organizationId = ISUtilsString.refineString(dictionary["organizationId"]);
    }
    if (dictionary.containsKey("claimId")) {
      claimId = ISUtilsString.refineString(dictionary["claimId"]);
    }
    if (dictionary.containsKey("mediaId")) {
      mediaId = ISUtilsString.refineString(dictionary["mediaId"]);
    }
    if (dictionary.containsKey("mimeType")) {
      enumMimeType = MediaMimeTypeExtension.fromString(
          ISUtilsString.refineString(dictionary["mimeType"]));
    }
    if (dictionary.containsKey("fileName")) {
      szFileName = ISUtilsString.refineString(dictionary["fileName"]);
    }
    if (dictionary.containsKey("originalName")) {
      szOriginalName = ISUtilsString.refineString(dictionary["originalName"]);
    }
    if (dictionary.containsKey("encoding")) {
      szEncoding = ISUtilsString.refineString(dictionary["encoding"]);
    }
    if (dictionary.containsKey("size")) {
      nSize = ISUtilsString.refineInt(dictionary["size"], 0);
    }
    if (dictionary.containsKey("note")) {
      szNote = ISUtilsString.refineString(dictionary["note"]);
    }

    if (id.isEmpty) {
      id = mediaId;
    } else if (mediaId.isEmpty) {
      mediaId = id;
    }
  }

  bool isValid() {
    return id.isNotEmpty && mediaId.isNotEmpty;
  }

  String getUrlString() {
    return ISUrlManager.claimApi
        .getEndpointForMediaWithId(organizationId, claimId, mediaId);
  }
}

enum EnumMediaMimeType { png, jpg, pdf }

extension MediaMimeTypeExtension on EnumMediaMimeType {
  static EnumMediaMimeType fromString(String? string) {
    if (string == null || string.isEmpty) return EnumMediaMimeType.png;

    if (string.toLowerCase() == EnumMediaMimeType.png.value.toLowerCase()) {
      return EnumMediaMimeType.png;
    } else if (string.toLowerCase() ==
        EnumMediaMimeType.jpg.value.toLowerCase()) {
      return EnumMediaMimeType.jpg;
    } else if (string.toLowerCase() ==
        EnumMediaMimeType.pdf.value.toLowerCase()) {
      return EnumMediaMimeType.pdf;
    }

    return EnumMediaMimeType.png;
  }

  String get value {
    switch (this) {
      case EnumMediaMimeType.png:
        return "image/png";
      case EnumMediaMimeType.jpg:
        return "image/jpg";
      case EnumMediaMimeType.pdf:
        return "application/pdf";
    }
  }
}
