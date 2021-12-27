import 'package:insurance/isModel/claim/dataModel/is_agent_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_contact_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_modified_by_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_policy_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_struct_coord.dart';
import 'package:insurance/isModel/events/dataModel/is_event_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISClaimDataModel {
  String id = "";
  String organizationId = "";
  String szClaimNumber = "";
  String szDescription = "";
  String szAddress = "";
  ISStructCoord coordLocation = ISStructCoord();
  ISPolicyDataModel modelPolicy = ISPolicyDataModel();
  List<ISClaimContactDataModel> arrayContacts = [];
  ISAgentDataModel modelAgent = ISAgentDataModel();
  ISAgentDataModel modelWriter = ISAgentDataModel();
  ISEventDataModel modelEvent = ISEventDataModel();
  List<ISNoteDataModel> arrayNotes = [];

  DateTime? dateLoss;
  DateTime? dateCreatedAt;
  DateTime? dateUpdatedAt;

  List<ISEnumClaimType> arrayTypes = [];
  ISEnumClaimStatus enumStatus = ISEnumClaimStatus.unknown;

  // Reserve Amounts
  int nAdjustedLossReserve = 0;
  int nLossPaidAmount = 0;
  int nTotalInsuredValue = 0;
  int nTotalLossReserve = 0;

  bool isOutdated = false;
  ISModifiedByDataModel modelModifiedBy = ISModifiedByDataModel();

  ISClaimDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    organizationId = "";
    szClaimNumber = "";
    szDescription = "";
    szAddress = "";
    coordLocation = ISStructCoord();

    modelPolicy = ISPolicyDataModel();
    arrayContacts = [];
    modelAgent = ISAgentDataModel();
    modelWriter = ISAgentDataModel();

    modelEvent = ISEventDataModel();
    arrayNotes = [];
    arrayTypes = [];
    enumStatus = ISEnumClaimStatus.unknown;
    dateLoss = null;
    dateCreatedAt = null;
    dateUpdatedAt = null;
    nAdjustedLossReserve = 0;
    nLossPaidAmount = 0;
    nTotalInsuredValue = 0;
    nTotalLossReserve = 0;
    isOutdated = false;

    modelModifiedBy = ISModifiedByDataModel();
  }

  List<dynamic> serializeNotes() {
    List<dynamic> notes = [];
    for (int i = 0; i < arrayNotes.length; i++) {
      ISNoteDataModel medium = arrayNotes[i];
      notes.add(medium.serializeForCreate());
    }
    return notes;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("claimId")) {
      id = ISUtilsString.refineString(dictionary["claimId"]);
    }
    if (dictionary.containsKey("organization") &&
        dictionary["organization"] != null) {

      Map<String, dynamic> org = dictionary["organization"];
      if (org.containsKey("organizationId") && org["organizationId"] != null) {
        organizationId =
            ISUtilsString.refineString(org["organizationId"]);
      }

    } else if (dictionary.containsKey("organizationId")) {
      // For backward compatibility
      organizationId = ISUtilsString.refineString(dictionary["organizationId"]);
    }
    if (dictionary.containsKey("claimNumber")) {
      szClaimNumber = ISUtilsString.refineString(dictionary["claimNumber"]);
    }
    if (dictionary.containsKey("description")) {
      szDescription = ISUtilsString.refineString(dictionary["description"]);
    }
    if (dictionary.containsKey("address")) {
      szAddress = ISUtilsString.refineString(dictionary["address"]);
    }
    if (dictionary.containsKey("geometry") && dictionary["geometry"] != null) {
      Map<String, dynamic> location = dictionary["geometry"];
      if (location.containsKey("coordinates") &&
          location["coordinates"] != null) {
        List<dynamic> coord = location["coordinates"];
        if (coord.length >= 2) {
          double lat = ISUtilsString.refineDouble(coord[1], 0.0);
          double lng = ISUtilsString.refineDouble(coord[0], 0.0);
          coordLocation = ISStructCoord(latitude: lat, longitude: lng);
        }
      }
    }

    if (dictionary.containsKey("policy") && dictionary["policy"] != null) {
      Map<String, dynamic> policy = dictionary["policy"];
      modelPolicy.deserialize(policy);
    }

    if (dictionary.containsKey("contacts") && dictionary["contacts"] != null) {
      List<dynamic> contacts = dictionary["contacts"];
      for (int i = 0; i < contacts.length; i++) {
        Map<String, dynamic> dict = contacts[i];
        ISClaimContactDataModel contact = ISClaimContactDataModel();
        contact.deserialize(dict);
        arrayContacts.add(contact);
      }
    }

    if (dictionary.containsKey("agent") && dictionary["agent"] != null) {
      modelAgent.deserialize(dictionary["agent"]);
    }
    if (dictionary.containsKey("writer") && dictionary["writer"] != null) {
      modelWriter.deserialize(dictionary["writer"]);
    }

    if (dictionary.containsKey("event") && dictionary["event"] != null) {
      modelEvent.deserialize(dictionary["event"]);
      modelEvent.id =
          ISUtilsString.refineString(dictionary["event"]["eventId"]);
    }
    deserializeNotes(dictionary);

    if (dictionary.containsKey("lossDate")) {
      dateLoss = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["lossDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }
    if (dictionary.containsKey("createdAt")) {
      dateLoss = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["createdAt"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("updatedAt")) {
      dateLoss = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["updatedAt"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("status")) {
      enumStatus = ClaimStatusExptension.fromString(
          ISUtilsString.refineString(dictionary["status"]));
    }

    if (dictionary.containsKey("type") && dictionary["type"] != null) {
      List<dynamic> types = dictionary["type"];
      for (int i = 0; i < types.length; i++) {
        String type = types[i];
        arrayTypes.add(ClaimTypeExtension.fromString(type));
      }
    }

    if (dictionary.containsKey("lastModifiedBy") &&
        dictionary["lastModifiedBy"] != null) {
      Map<String, dynamic> modifiedBy = dictionary["lastModifiedBy"];
      modelModifiedBy.deserialize(modifiedBy);
    }

    if (dictionary.containsKey("reserves") && dictionary["reserves"] != null) {
      Map<String, dynamic> reserves = dictionary["reserves"];
      nAdjustedLossReserve =
          ISUtilsString.refineInt(reserves["adjustedLossReserve"], 0);
      nLossPaidAmount = ISUtilsString.refineInt(reserves["lossPaidAmount"], 0);
      nTotalInsuredValue =
          ISUtilsString.refineInt(reserves["totalInsuredValue"], 0);
      nTotalLossReserve =
          ISUtilsString.refineInt(reserves["totalLossReserve"], 0);
    }
  }

  deserializeNotes(Map<String, dynamic>? dictionary) {
    arrayNotes = [];
    if (dictionary == null) return;

    if (dictionary.containsKey("notes") && dictionary["notes"] != null) {
      List<dynamic> notes = dictionary["notes"];
      for (int i = 0; i < notes.length; i++) {
        Map<String, dynamic> dict = notes[i];
        ISNoteDataModel note = ISNoteDataModel();
        note.deserialize(dict);

        for (int j = 0; j < note.arrayMedia.length; i++) {
          ISMediaDataModel medium = note.arrayMedia[j];
          medium.organizationId = organizationId;
          medium.claimId = id;
        }
        if (note.isValid()) {
          arrayNotes.add(note);
        }
      }
    }
  }

  invalidate() {
    isOutdated = true;
  }

  bool isValid() {
    if (id.isEmpty || isOutdated) return false;

    if (organizationId.isEmpty) {
      return false;
    }
    return true;
  }
}

enum ISEnumClaimStatus {
  unknown,
  _new,
  pending,
  scheduled,
  inProgress,
  completed,
  closed,
  deleted,
}

extension ClaimStatusExptension on ISEnumClaimStatus {
  static ISEnumClaimStatus fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumClaimStatus.unknown;
    }
    for (var t in ISEnumClaimStatus.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumClaimStatus.unknown;
  }

  String get value {
    switch (this) {
      case ISEnumClaimStatus.unknown:
        return "";
      case ISEnumClaimStatus._new:
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

enum ISEnumClaimType { none, fire, theft, lightening, hail, flood, wind, other }

extension ClaimTypeExtension on ISEnumClaimType {
  static ISEnumClaimType fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumClaimType.fire;
    }
    for (var t in ISEnumClaimType.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumClaimType.none;
  }

  String get value {
    switch (this) {
      case ISEnumClaimType.none:
        return "";
      case ISEnumClaimType.fire:
        return "Fire";
      case ISEnumClaimType.theft:
        return "Theft";
      case ISEnumClaimType.lightening:
        return "Lightening";
      case ISEnumClaimType.hail:
        return "Hail";
      case ISEnumClaimType.flood:
        return "Flood";
      case ISEnumClaimType.wind:
        return "Wind";
      case ISEnumClaimType.other:
        return "Other";
    }
  }

  int toInt() {
    switch (this) {
      case ISEnumClaimType.none:
        return -1;
      case ISEnumClaimType.fire:
        return 0;
      case ISEnumClaimType.theft:
        return 1;
      case ISEnumClaimType.lightening:
        return 2;
      case ISEnumClaimType.hail:
        return 3;
      case ISEnumClaimType.flood:
        return 4;
      case ISEnumClaimType.wind:
        return 5;
      case ISEnumClaimType.other:
        return 6;
      default:
        return -1;
    }
  }

  static List<String> getAvailableValue() {
    return [
      ISEnumClaimType.fire.value,
      ISEnumClaimType.theft.value,
      ISEnumClaimType.lightening.value,
      ISEnumClaimType.hail.value,
      ISEnumClaimType.flood.value,
      ISEnumClaimType.wind.value,
      ISEnumClaimType.other.value
    ];
  }
}
