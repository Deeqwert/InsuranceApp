
import 'package:insurance/isModel/communications/is_network_manager_response.dart';

class ISOfflineRequestDataModel {
  String endpoint = "";
  Map<String, dynamic>? params;
  int authOptions = 0;
  ISNetworkManagerResponse? callback;
  String? method;

  ISOfflineRequestDataModel() {
    initialize();
  }

  initialize() {
    endpoint = "";
    params = null;
    authOptions = 0;
    callback = null;
    method = null;
  }
}
