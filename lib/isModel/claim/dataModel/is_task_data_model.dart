import 'package:flutter/material.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_contact_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_hover_link_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_modified_by_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_struct_coord.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_ref_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_submission_ref_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/organization/dataModel/is_organization_data_model.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';

class ISTaskDataModel {
  String id = "";
  String szName = "";
  String szDescription = "";
  ISOrganizationDataModel modelOrganization = ISOrganizationDataModel();
  ISUserDataModel modelUser = ISUserDataModel();
  List<ISNoteDataModel> arrayNotes = [];

  ISClaimDataModel modelClaim = ISClaimDataModel();

  DateTime? dateScheduledStart;
  DateTime? dateScheduledEnd;
  DateTime? dateActualStart;
  DateTime? dateActualEnd;
  DateTime? dateFirstContact;

  ISStructCoord coordLocation = ISStructCoord(latitude: 0.0, longitude: 0.0);
  ISEnumTaskStatus enumStatus = ISEnumTaskStatus.pending;

  String szType = "";
  List<ISFormRefDataModel> arrayFormsRef = [];
  List<ISFormSubmissionRefDataModel> arraySubmissionsRef = [];
  ISHoverLinkDataModel modelHoverLink = ISHoverLinkDataModel();
  bool isOutdated = false;

  DateTime? dateCreatedAt;
  DateTime? dateUpdatedAt;

  ISModifiedByDataModel modelModifiedBy = ISModifiedByDataModel();

  Map<String, dynamic> payload = {};

  ISTaskDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    szName = "";
    szDescription = "";
    modelOrganization = ISOrganizationDataModel();
    modelUser = ISUserDataModel();
    arrayNotes = [];

    modelClaim = ISClaimDataModel();

    dateScheduledStart = null;
    dateScheduledEnd = null;
    dateActualStart = null;
    dateActualEnd = null;
    dateFirstContact = null;

    coordLocation = ISStructCoord(latitude: 0.0, longitude: 0.0);

    szType = "";
    arrayFormsRef = [];
    arraySubmissionsRef = [];
    modelHoverLink = ISHoverLinkDataModel();
    enumStatus = ISEnumTaskStatus.pending;
    isOutdated = false;

    dateCreatedAt = null;
    dateUpdatedAt = null;
    modelModifiedBy = ISModifiedByDataModel();

    payload = {};
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("id"))
      id = ISUtilsString.refineString(dictionary["id"]);
    if (dictionary.containsKey("name"))
      szName = ISUtilsString.refineString(dictionary["name"]);
    if (dictionary.containsKey("description"))
      szDescription = ISUtilsString.refineString(dictionary["description"]);

    if (dictionary.containsKey("organization") &&
        dictionary["organization"] != null) {
      Map<String, dynamic> org = dictionary["organization"];
      modelOrganization.deserialize(org);
      modelOrganization.id = ISUtilsString.refineString(org["organizationId"]);
    }

    if (dictionary.containsKey("user") && dictionary["user"] != null) {
      Map<String, dynamic> user = dictionary["user"];
      modelUser.deserialize(user);
      modelUser.id = modelUser.userId;
    }

    if (dictionary.containsKey("notes") && dictionary["notes"] != null) {
      List<dynamic> notes = dictionary["notes"];

      for (int i = 0; i < notes.length; i++) {
        Map<String, dynamic> dict = notes[i];
        ISNoteDataModel note = ISNoteDataModel();
        note.deserialize(dict);
        if (note.isValid()) {
          arrayNotes.add(note);
        }
      }
    }

    if (dictionary.containsKey("currentLocation") &&
        dictionary["currentLocation"] != null) {
      Map<String, dynamic> location = dictionary["currentLocation"];
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

    if (dictionary.containsKey("type")) {
      szType = ISUtilsString.refineString(dictionary["type"]);
    }

    if (dictionary.containsKey("forms") && dictionary["forms"] != null) {
      List<dynamic> forms = dictionary["forms"];

      for (int i = 0; i < forms.length; i++) {
        Map<String, dynamic> dict = forms[i];
        ISFormRefDataModel formRef = ISFormRefDataModel();
        formRef.deserialize(dict);
        if (formRef.isValid()) {
          arrayFormsRef.add(formRef);
        }
      }
    }

    if (dictionary.containsKey("submissions") &&
        dictionary["submissions"] != null) {
      List<dynamic> submissions = dictionary["submissions"];

      for (int i = 0; i < submissions.length; i++) {
        Map<String, dynamic> dict = submissions[i];
        ISFormSubmissionRefDataModel submissionRef =
            ISFormSubmissionRefDataModel();
        submissionRef.deserialize(dict);
        if (submissionRef.isValid()) {
          arraySubmissionsRef.add(submissionRef);
        }
      }
    }

    if (dictionary.containsKey("claim") && dictionary["claim"] != null) {
      Map<String, dynamic> claim = dictionary["claim"];
      modelClaim.deserialize(claim);
    }

    deserializeNotes(modelOrganization.id, modelClaim.id, dictionary);

    if (dictionary.containsKey("scheduleStartDate")) {
      dateScheduledStart = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["scheduleStartDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("scheduleEndDate")) {
      dateScheduledEnd = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["scheduleEndDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("actualStartDate")) {
      dateActualStart = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["actualStartDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("actualEndDate")) {
      dateActualEnd = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["actualEndDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("firstContactDate")) {
      dateFirstContact = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["firstContactDate"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("createdAt")) {
      dateCreatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["createdAt"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("updatedAt")) {
      dateUpdatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
          ISUtilsString.refineString(dictionary["updatedAt"]),
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }

    if (dictionary.containsKey("lastModifiedBy") &&
        dictionary["lastModifiedBy"] != null) {
      Map<String, dynamic> dic = dictionary["lastModifiedBy"];
      modelModifiedBy.deserialize(dic);
    }

    if (dictionary.containsKey("hover") && dictionary["hover"] != null) {
      Map<String, dynamic> dic = dictionary["hover"];
      modelHoverLink.deserialize(dic);
    }

    if (dictionary.containsKey("status"))
      enumStatus = TaskStatusExtension.fromString(
          ISUtilsString.refineString(dictionary["status"]));

    payload = dictionary;
  }

  ISClaimDataModel? getClaimDataModel() {
    return modelClaim;
  }

  Map<String, dynamic> serializeForFormSubmissions() {
    List<dynamic> jsonArray = [];
    for (var ref in arraySubmissionsRef) {
      Map<String, dynamic> json = ref.serialize();
      jsonArray.add(json);
    }
    Map<String, dynamic> result = {};

    result["submissions"] = jsonArray;

    return result;
  }

  Map<String, dynamic> serializeForNotes() {
    List<dynamic> array = [];
    for (int i = 0; i < arrayNotes.length; i++) {
      ISNoteDataModel note = arrayNotes[i];
      array.add(note.serializeForUpdate());
    }
    Map<String, dynamic> json = {};
    json["notes"] = array;

    return json;
  }

  Map<String, dynamic> serializeForReserves() {
    Map<String, dynamic> jsonObject = {};
    var claimData = getClaimDataModel();
    if (claimData != null) {
      jsonObject["adjustedLossReserve"] = claimData.nAdjustedLossReserve;
    }
    return jsonObject;
  }

  Map<String, dynamic> serializeForOffline() {
    Map<String, dynamic> dictionary = payload;

    // Merge submissions
    Map<String, dynamic> submissions = serializeForFormSubmissions();

    List<dynamic> submissionsArray = submissions["submissions"];
    dictionary["submissions"] = submissionsArray;
    dictionary["status"] = enumStatus;

    // Merge notes
    Map<String, dynamic> notes = serializeForNotes();

    List<dynamic> notesArray = notes["notes"];
    dictionary["notes"] = notesArray;

    return dictionary;
  }

  invalidate() {
    isOutdated = true;
  }

  bool isValid() {
    var currentUser = ISUserManager.sharedInstance.currentUser;

    if (currentUser == null) return false;

    if (!ISUserManager.sharedInstance.isLoggedIn()) return false;

    return (id.isNotEmpty &&
        modelUser.id == currentUser.id &&
        !isOutdated &&
        enumStatus != ISEnumTaskStatus.declined &&
        /* enumStatus != ISEnumTaskStatus.failed && */
        enumStatus != ISEnumTaskStatus.cancelled &&
        enumStatus != ISEnumTaskStatus.partnerPending);
  }

  bool isAppointmentSet() {
    return (dateScheduledStart != null && dateScheduledEnd != null);
  }

  bool isInProgress() {
    return (enumStatus == ISEnumTaskStatus.enRoute ||
        enumStatus == ISEnumTaskStatus.arrived ||
        enumStatus == ISEnumTaskStatus.departed);
  }

  bool isScheduledOrInProgress() {
    return (enumStatus == ISEnumTaskStatus.scheduled || isInProgress());
  }

  deserializeNotes(
      String organizationId, String claimId, Map<String, dynamic>? dictionary) {
    arrayNotes = [];

    if (dictionary == null) return;

    if (dictionary.containsKey("notes") && dictionary["notes"] != null) {
      List<dynamic> notes = dictionary["notes"];
      for (int i = 0; i < notes.length; i++) {
        Map<String, dynamic> dict = notes[i];
        ISNoteDataModel note = ISNoteDataModel();
        note.deserialize(dict);
        for (var medium in note.arrayMedia) {
          medium.organizationId = organizationId;
          medium.claimId = claimId;
        }

        if (note.isValid()) {
          arrayNotes.add(note);
        }
      }
    }
  }

  // MARK : Getters

  // Claim

  String getClaimNumber() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.szClaimNumber;
    }
    return "N/A";
  }

  String getClaimType() {
    return "N/A";
  }

  DateTime? getLossDate() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.dateLoss;
    }
    return null;
  }

  String getFormattedLossDate() {
    if (getLossDate() != null) {
      return ISUtilsDate.getStringFromDateTimeWithFormat(
          getLossDate(), ISEnumDateTimeFormat.MMddyyyy_hhmma.value, false);
    }
    return "N/A";
  }

  //Contacts

  String getContactName() {
    var claim = getClaimDataModel();
    if (claim != null) {
      if (claim.arrayContacts.length > 0) {
        ISClaimContactDataModel contact = claim.arrayContacts[0];
        return contact.szName;
      } else {
        return "N/A";
      }
    }
    return "N/A";
  }

  String getContactEmailAddress() {
    var claim = getClaimDataModel();
    if (claim != null) {
      if (claim.arrayContacts.length > 0) {
        ISClaimContactDataModel contact = claim.arrayContacts[0];
        return contact.szEmail;
      } else {
        return "N/A";
      }
    }
    return "N/A";
  }

  String getContactPhoneNumber() {
    var claim = getClaimDataModel();
    if (claim != null) {
      if (claim.arrayContacts.length > 0) {
        ISClaimContactDataModel contact = claim.arrayContacts[0];
        return contact.szPhone;
      } else {
        return "N/A";
      }
    }
    return "N/A";
  }

  String getEventName() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.modelEvent.szName;
    }

    return "N/A";
  }

  String getPolicyNumber() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.modelPolicy.szPolicyNumber;
    }
    return "N/A";
  }

  DateTime? getPolicyEffectiveDate() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.modelPolicy.dateExpiration;
    }
    return null;
  }

  DateTime? getPolicyExpirationDate() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.modelPolicy.dateExpiration;
    }
    return null;
  }

  String getFormattedPolicyEffectiveDate() {
    if (getPolicyEffectiveDate() != null && getPolicyExpirationDate() != null) {
      String str = ISUtilsDate.getStringFromDateTimeWithFormat(
              getPolicyEffectiveDate(),
              ISEnumDateTimeFormat.MMddyyyy.value,
              false) +
          " ~ " +
          ISUtilsDate.getStringFromDateTimeWithFormat(getPolicyExpirationDate(),
              ISEnumDateTimeFormat.MMddyyyy.value, false);

      return str;
    }
    return "N/A";
  }

  String getPolicyType() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.modelPolicy.szType;
    }

    return "N/A";
  }

  ISStructCoord? getBestCoordinates() {
    if (isInProgress() && coordLocation.isValid()) {
      return coordLocation;
    }

    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.coordLocation;
    }

    return null;
  }

  DateTime? getBestStartDate() {
    if (dateActualStart != null) {
      return dateActualStart;
    }
    if (dateScheduledStart != null) {
      return dateScheduledStart;
    }
    return null;
  }

  DateTime? getBestEndDate() {
    if (dateActualEnd != null) {
      return dateActualEnd;
    }

    if (dateScheduledEnd != null) {
      return dateScheduledEnd;
    }
    return null;
  }

  String getFormattedBestStartDateString() {
    if (getBestStartDate() != null) {
      return ISUtilsDate.getStringFromDateTimeWithFormat(
          getBestStartDate(), ISEnumDateTimeFormat.MMMdyyyy.value, false);
    } else {
      return "N/A";
    }
  }

  String getFormattedBestStartTimeString() {
    if (getBestStartDate() != null) {
      return ISUtilsDate.getStringFromDateTimeWithFormat(
          getBestStartDate(), ISEnumDateTimeFormat.hhmma.value, false);
    } else {
      return "N/A";
    }
  }

  String getFormattedBestEndDateString() {
    if (getBestEndDate() != null) {
      return ISUtilsDate.getStringFromDateTimeWithFormat(
          getBestEndDate(), ISEnumDateTimeFormat.MMddyyyy.value, false);
    } else {
      return "N/A";
    }
  }

  String getFormattedBestEndTimeString() {
    if (getBestEndDate() != null) {
      return ISUtilsDate.getStringFromDateTimeWithFormat(
          getBestEndDate(), ISEnumDateTimeFormat.hhmma.value, false);
    } else {
      return "N/A";
    }
  }

  String getAddress() {
    var claim = getClaimDataModel();
    if (claim != null) {
      return claim.szAddress;
    }
    return "N/A";
  }

  Color getColorStatus() {
    return enumStatus.toColor();
  }

  Color getColorForeground() {
    if (enumStatus == ISEnumTaskStatus.completed)
      return Color.fromRGBO(169, 169, 169, 0);
    return Color.fromRGBO(255, 255, 255, 0);
  }

  String getIconStatus() {
    return enumStatus.toIconStatus();
  }

  bool hasAdjusterForm() {
    return (szType.isNotEmpty && arrayFormsRef.isNotEmpty);
  }

  bool isAdjusterFormSubmitted() {
    if (!hasAdjusterForm()) {
      return false;
    }
    if (arraySubmissionsRef.isEmpty) {
      return false;
    }
    for (var formRef in arrayFormsRef) {
      bool isSubmitted = false;
      for (var submissionRef in arraySubmissionsRef) {
        if (submissionRef.szFormName == formRef.szName) {
          isSubmitted = true;
          break;
        }
      }

      if (!isSubmitted) {
        return false;
      }
    }

    return true;
  }

  ISFormSubmissionRefDataModel? getAdjusterFormSubmissionRefByFormRef(
      ISFormRefDataModel formRef) {
    for (var submissionRef in arraySubmissionsRef) {
      if (submissionRef.szFormName == formRef.szName) return submissionRef;
    }

    return null;
  }

  addSubmissionRefIfNeeded(ISFormSubmissionRefDataModel submissionRef) {
    // We need to check if the submission for same form is already added or not.
    // FOR NOW: We just add, without checking if already added

    for (int i = 0; i < arraySubmissionsRef.length; i++) {
      ISFormSubmissionRefDataModel ref = arraySubmissionsRef[i];
      if (ref.submissionId == submissionRef.submissionId) return;
    }
    arraySubmissionsRef.add(submissionRef);
  }

  addNoteIfNeeded(ISNoteDataModel newNote) {
    for (int i = 0; i < arrayNotes.length; i++) {
      ISNoteDataModel note = arrayNotes[i];
      if (note.id == newNote.id) return;
    }
    arrayNotes.add(newNote);
  }

  ISNoteDataModel? getNoteById(String noteId) {
    for (var note in arrayNotes) {
      if (note.id == noteId) return note;
    }
    return null;
  }
}

enum ISEnumTaskStatus {
  none,
  pending,
  partnerPending,
  assigned,
  scheduled,
  enRoute,
  arrived,
  departed,
  checkInDeparted,
  checkoutDeparted,
  completed,
  deleted,
  failed,
  declined,
  cancelled
}

extension TaskStatusExtension on ISEnumTaskStatus {
  static ISEnumTaskStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumTaskStatus.none;
    }
    for (ISEnumTaskStatus s in ISEnumTaskStatus.values) {
      if (s.value == str) {
        if (s == ISEnumTaskStatus.checkInDeparted) {
          return ISEnumTaskStatus.arrived;
        }
        if (s == ISEnumTaskStatus.checkoutDeparted) {
          return ISEnumTaskStatus.departed;
        }
        return s;
      }
    }
    return ISEnumTaskStatus.none;
  }

  String get value {
    switch (this) {
      case ISEnumTaskStatus.none:
        return "";
      case ISEnumTaskStatus.pending:
        return "Pending";
      case ISEnumTaskStatus.partnerPending:
        return "Partner Pending";
      case ISEnumTaskStatus.assigned:
        return "Assigned";
      case ISEnumTaskStatus.scheduled:
        return "Scheduled";
      case ISEnumTaskStatus.enRoute:
        return "En Route";
      case ISEnumTaskStatus.arrived:
        return "Arrived";
      case ISEnumTaskStatus.departed:
        return "Departed";
      case ISEnumTaskStatus.checkInDeparted:
        return "Check In";
      case ISEnumTaskStatus.checkoutDeparted:
        return "Check Out";
      case ISEnumTaskStatus.completed:
        return "Completed";
      case ISEnumTaskStatus.deleted:
        return "Deleted";
      case ISEnumTaskStatus.failed:
        return "Failed";
      case ISEnumTaskStatus.declined:
        return "Declined";
      case ISEnumTaskStatus.cancelled:
        return "Cancelled";
    }
  }

  int toInt() {
    switch (this) {
      case ISEnumTaskStatus.none:
        return -1;
      case ISEnumTaskStatus.pending:
        return 0;
      case ISEnumTaskStatus.partnerPending:
        return 1;
      case ISEnumTaskStatus.assigned:
        return 2;
      case ISEnumTaskStatus.scheduled:
        return 3;
      case ISEnumTaskStatus.enRoute:
        return 4;
      case ISEnumTaskStatus.arrived:
        return 5;
      case ISEnumTaskStatus.departed:
        return 6;
      case ISEnumTaskStatus.completed:
        return 7;
      case ISEnumTaskStatus.declined:
        return 8;
      case ISEnumTaskStatus.deleted:
        return 9;
      case ISEnumTaskStatus.failed:
        return 10;
      case ISEnumTaskStatus.cancelled:
        return 11;
      default:
        return -1;
    }
  }

  String toStringForUpdateEndpoint() {
    if (this == ISEnumTaskStatus.assigned) {
      return "accept";
    }
    if (this == ISEnumTaskStatus.scheduled) {
      return "schedule";
    }
    if (this == ISEnumTaskStatus.enRoute) {
      return "en-route";
    }
    if (this == ISEnumTaskStatus.arrived) {
      return "arrive";
    }
    if (this == ISEnumTaskStatus.departed) {
      return "depart";
    }
    if (this == ISEnumTaskStatus.completed) {
      return "complete";
    }
    if (this == ISEnumTaskStatus.declined) {
      return "decline";
    }
    if (this == ISEnumTaskStatus.cancelled) {
      return "cancel";
    }
    return this.value.toLowerCase();
  }

  static List<String> getAvailableValues() {
    return [
      ISEnumTaskStatus.pending.value,
      ISEnumTaskStatus.assigned.value,
      ISEnumTaskStatus.scheduled.value,
      ISEnumTaskStatus.enRoute.value,
      ISEnumTaskStatus.arrived.value,
      ISEnumTaskStatus.departed.value,
      ISEnumTaskStatus.declined.value
    ];
  }

  Color toColor() {
    if (this == ISEnumTaskStatus.pending) {
      return  Color(0xffab3428);
    } else if (this == ISEnumTaskStatus.assigned) {
      return  Color(0xff2d728f);
    } else if (this == ISEnumTaskStatus.scheduled) {
      return  Color(0xfff49e4c);
    } else if (this == ISEnumTaskStatus.enRoute) {
      return  Color(0xffc8721f);
    } else if (this == ISEnumTaskStatus.arrived) {
      return  Color(0xff63ba15);
    } else if (this == ISEnumTaskStatus.departed) {
      return  Color(0xff478c09);
    } else if (this == ISEnumTaskStatus.completed) {
      return  Color(0xfff5ee9e);
    } else if (this == ISEnumTaskStatus.failed) {
      return  Color(0xffb7b7b7);
    }
    return  Color(0xffab3428);
  }

  String toIconStatus() {
    if (this == ISEnumTaskStatus.pending) {
      return "assets/images/ic_pin_pending.png";
    }
    if (this == ISEnumTaskStatus.assigned) {
      return "assets/images/ic_pin_assigned.png";
    }
    if (this == ISEnumTaskStatus.scheduled) {
      return "assets/images/ic_pin_scheduled.png";
    }
    if (this == ISEnumTaskStatus.enRoute) {
      return "assets/images/ic_pin_en_route.png";
    }
    if (this == ISEnumTaskStatus.arrived) {
      return "assets/images/ic_pin_arrived.png";
    }
    if (this == ISEnumTaskStatus.departed) {
      return "assets/images/ic_pin_departed.png";
    }
    if (this == ISEnumTaskStatus.completed) {
      return "assets/images/ic_pin_completed.png";
    }
    if (this == ISEnumTaskStatus.failed) {
      return "assets/images/ic_pin_square_gray.png";
    }
    return "assets/images/ic_pin_square_gray.png";
  }
}
