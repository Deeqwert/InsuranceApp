import 'package:insurance/isModel/communications/is_offline_request_data_model.dart';

class ISOfflineRequestManager {
  List<ISOfflineRequestDataModel> arrayRequestQueue = [];

  static ISOfflineRequestManager sharedInstance = ISOfflineRequestManager();

  enqueueRequest(ISOfflineRequestDataModel httpRequest) {
    for (var request in arrayRequestQueue) {
      if (request.endpoint == httpRequest.endpoint) return;
    }
    arrayRequestQueue.add(httpRequest);
  }

  dequeueRequest(ISOfflineRequestDataModel httpRequest) {
    int index = 0;
    for (var request in arrayRequestQueue) {
      if (request.endpoint == httpRequest.endpoint) {
        arrayRequestQueue.removeAt(index);
        return;
      }
      index += 1;
    }
  }
}
