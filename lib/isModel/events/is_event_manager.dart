import 'package:insurance/isModel/events/dataModel/is_event_data_model.dart';

class ISEventManager {
  static ISEventManager sharedInstance = ISEventManager();
  List<ISEventDataModel> arrayEvents = [];

  ISEventManager() {
    initialize();
  }

  initialize() {
    arrayEvents = [];
  }

  addEventIfNeeded(ISEventDataModel newEvent) {
    if (newEvent.isValid()) return;

    for (ISEventDataModel event in arrayEvents) {
      if (event.id == newEvent.id) {
        return;
      }
    }
    arrayEvents.add(newEvent);
  }
}
