import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_page_data_model.dart';

class ISFormConfigurationDataModel {
  String szFormName = "";
  List<String> arrayReportTemplates = [];
  List<ISFormPageDataModel> arrayPages = [];
  Map<String, dynamic> payload = {};

  ISFormConfigurationDataModel() {
    initialize();
  }

  initialize() {
    szFormName = "";
    arrayReportTemplates = [];
    arrayPages = [];
    payload = {};
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;
    payload = dictionary;

    if (dictionary.containsKey("name")) {
      szFormName = ISUtilsString.refineString(dictionary["name"]);
    }

    if (dictionary.containsKey("reportTemplates")) {
      var reportTemplates = dictionary["reportTemplates"];

      if (reportTemplates is List<String>) {
        arrayReportTemplates = reportTemplates;
      }
    }
    // Backwards compatibility
    else if (dictionary.containsKey("reportTemplate")) {
      final template = ISUtilsString.refineString(dictionary["name"]);
      if (template.isNotEmpty) {
        arrayReportTemplates.add(template);
      }
    }

    if (dictionary.containsKey("pages")) {
      final List<dynamic> pages = dictionary["pages"];
      for (int i in Iterable.generate(pages.length)) {
        var page = ISFormPageDataModel();
        page.deserialize(pages[i]);
        if (page.isValid()) {
          arrayPages.add(page);
        }
      }
    }
  }

  Map<String, dynamic> serialize() {
    List<dynamic> array = [];
    for (var page in arrayPages) {
      array.add(page.serialize());
    }

    List<dynamic> arrayReportTemplates = [];
    for (var template in arrayReportTemplates) {
      arrayReportTemplates.add(template);
    }
    final Map<String, dynamic> jsonObject = {};
    try {
      jsonObject["name"] = szFormName;
      jsonObject["reportTemplates"] = arrayReportTemplates;
      jsonObject["pages"] = array;
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    return jsonObject;
  }

  bool isValid() => arrayPages.isNotEmpty;
}
