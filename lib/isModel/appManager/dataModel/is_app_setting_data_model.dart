import 'package:insurance/isModel/is_utils_string.dart';

class ISAppSettingDataModel {
  ISEnumSettingMapViewPreference enumMapPreference =
      ISEnumSettingMapViewPreference.none;

  ISAppSettingDataModel() {
    initialize();
  }

  void initialize() {
    enumMapPreference = ISEnumSettingMapViewPreference.none;
  }

  void deserialize(Map<String, dynamic>? dictionary) {
    this.initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("map_preference") &&
        dictionary["map_preference"] != null)
      this.enumMapPreference = SettingMapViewPreferenceExtension.fromString(
          ISUtilsString.refineString(dictionary["map_preference"]));
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> json = {};

    json["map_preference"] = enumMapPreference.value;

    return json;
  }
}

enum ISEnumSettingMapViewPreference {
  none,
  waze,
  googleMaps,
  appleMaps,
  hereWeGo
}

extension SettingMapViewPreferenceExtension on ISEnumSettingMapViewPreference {
  static ISEnumSettingMapViewPreference fromString(String? status) {
    if (status == null || status == "") {
      return ISEnumSettingMapViewPreference.none;
    }
    for (ISEnumSettingMapViewPreference t
    in ISEnumSettingMapViewPreference.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumSettingMapViewPreference.none;
  }

  String get title {
    switch (this) {
      case ISEnumSettingMapViewPreference.none:
        return "None";
      case ISEnumSettingMapViewPreference.waze:
        return "Waze App";
      case ISEnumSettingMapViewPreference.googleMaps:
        return "Google Maps App";
      case ISEnumSettingMapViewPreference.appleMaps:
        return "Apple Maps App";
      case ISEnumSettingMapViewPreference.hereWeGo:
        return "HERE WeGo App";
    }
  }

  String get value {
    switch (this) {
      case ISEnumSettingMapViewPreference.none:
        return "";
      case ISEnumSettingMapViewPreference.waze:
        return "Waze";
      case ISEnumSettingMapViewPreference.googleMaps:
        return "GoogleMaps";
      case ISEnumSettingMapViewPreference.appleMaps:
        return "AppleMaps";
      case ISEnumSettingMapViewPreference.hereWeGo:
        return "HERE WeGo";
    }
  }
}
