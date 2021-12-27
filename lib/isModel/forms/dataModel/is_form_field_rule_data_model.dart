class ISFormFieldRuleDataModel {
  ISEnumFormFieldRuleCondition enumCondition =
      ISEnumFormFieldRuleCondition.equals;
  ISEnumFormFieldRuleAction enumAction = ISEnumFormFieldRuleAction.show;
  ISEnumFormFieldRuleAction enumElseAction = ISEnumFormFieldRuleAction.hide;

  List<String> arrayValues = [];

  List<String> arrayTargetKeys = [];

  ISFormFieldRuleDataModel() {
    initialize();
  }

  initialize() {
    enumCondition = ISEnumFormFieldRuleCondition.equals;
    enumAction = ISEnumFormFieldRuleAction.show;
    enumElseAction = ISEnumFormFieldRuleAction.hide;
    arrayValues = [];
    arrayTargetKeys = [];
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;

    enumCondition =
        FormFieldRuleConditionExtension.fromString(dictionary["condition"]);
    enumAction = FormFieldRuleActionExtension.fromString(dictionary["action"]);
    enumElseAction =
        FormFieldRuleActionExtension.fromString(dictionary["elseAction"]);
    var values = dictionary["values"];
    if (values is List<String>) {
      arrayValues = values;
    } else {
      arrayValues = [];
    }

    var targetKeys = dictionary["targetKeys"];
    if (targetKeys is List<String>) {
      arrayTargetKeys = targetKeys;
    } else {
      arrayTargetKeys = [];
    }
  }

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> jsonObject = {};
    final List<dynamic> values = [];
    final List<dynamic> keys = [];
    values.add(arrayValues);
    keys.add(arrayTargetKeys);
    jsonObject["condition"] = enumCondition.value;
    jsonObject["action"] = enumAction.value;
    jsonObject["elseAction"] = enumElseAction.value;
    for (var str in arrayValues) {
      values.add(str);
    }
    jsonObject["values"] = values;
    for (var str in arrayTargetKeys) {
      keys.add(str);
    }
    jsonObject["targetKeys"] = keys;
    return jsonObject;
  }

  bool isValid() => arrayValues.isNotEmpty && arrayTargetKeys.isNotEmpty;

  bool testValue(dynamic value) {
    if (enumCondition == ISEnumFormFieldRuleCondition.equals) {
      if (arrayValues.length != 1) return false;
      var parsedValue = "";
      if (value is String) parsedValue = value;
      return parsedValue == arrayValues[0];
    } else if (enumCondition == ISEnumFormFieldRuleCondition.equalsAny) {
      var parsedValue = "";
      if (value is String) parsedValue = value;
      if (arrayValues.isNotEmpty) {
        for (var str in arrayValues) {
          if (parsedValue.toLowerCase() == str.toLowerCase()) return true;
        }
      }
      return false;
    } else if (enumCondition == ISEnumFormFieldRuleCondition.notEquals) {
      var parsedValue = "";
      if (value is String) parsedValue = value;
      if (arrayValues.isNotEmpty) {
        for (var str in arrayValues) {
          if (parsedValue.toLowerCase() == str.toLowerCase()) return false;
        }
      }
      return true;
    } else if (enumCondition == ISEnumFormFieldRuleCondition.containsAny) {
      List<String?> parsedValues = [];
      if (value is List<dynamic>) {
        parsedValues = value as List<String?>;
      }
      for (var v in arrayValues) {
        if (parsedValues.contains(v)) return true;
      }
      return false;
    } else if (enumCondition == ISEnumFormFieldRuleCondition.containsAll) {
      List<String?> parsedValues = [];
      if (value is List<dynamic>) parsedValues = value as List<String?>;
      for (var v in arrayValues) {
        if (!parsedValues.contains(v)) return false;
      }
      return true;
    } else if (enumCondition == ISEnumFormFieldRuleCondition.notContains) {
      List<String?> parsedValues = [];
      if (value is List<dynamic>) parsedValues = value as List<String?>;
      for (var v in arrayValues) {
        if (parsedValues.contains(v)) return false;
      }
      return true;
    } else {
      return false;
    }
  }
}

enum ISEnumFormFieldRuleCondition {
  equals,
  equalsAny,
  notEquals,
  containsAny,
  containsAll,
  notContains
}

extension FormFieldRuleConditionExtension on ISEnumFormFieldRuleCondition {
  static ISEnumFormFieldRuleCondition fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormFieldRuleCondition.equals;
    }
    for (var t in ISEnumFormFieldRuleCondition.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormFieldRuleCondition.equals;
  }

  String get value {
    switch (this) {
      case ISEnumFormFieldRuleCondition.equals:
        return "equals";
      case ISEnumFormFieldRuleCondition.equalsAny:
        return "equals_any";
      case ISEnumFormFieldRuleCondition.notEquals:
        return "not_equals";
      case ISEnumFormFieldRuleCondition.containsAny:
        return "contains_any";
      case ISEnumFormFieldRuleCondition.containsAll:
        return "contains_all";
      case ISEnumFormFieldRuleCondition.notContains:
        return "not_contains";
    }
  }
}

enum ISEnumFormFieldRuleAction {
  show,
  hide,
}

extension FormFieldRuleActionExtension on ISEnumFormFieldRuleAction {
  static ISEnumFormFieldRuleAction fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormFieldRuleAction.show;
    }
    for (var t in ISEnumFormFieldRuleAction.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormFieldRuleAction.show;
  }

  String get value {
    switch (this) {
      case ISEnumFormFieldRuleAction.show:
        return "show";
      case ISEnumFormFieldRuleAction.hide:
        return "hide";
    }
  }
}
