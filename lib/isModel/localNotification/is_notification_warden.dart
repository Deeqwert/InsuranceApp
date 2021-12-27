import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observable.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';



class ISNotificationWarden extends ISNotificationObservable {
  List<ISNotificationObserver?> _observers = [];
  static ISNotificationWarden sharedInstance = ISNotificationWarden();

  @override
  bool addObserver(ISNotificationObserver? o) {
    if (o != null && !_observers.contains(o)) {
      _observers.add(o);
      return true;
    }
    return false;
  }


  @override
  removeAllObservers() {
    _observers.clear();
  }

  @override
  bool removeObserver(ISNotificationObserver? o) {
    if (o != null) {
      _observers.remove(o);
      return true;
    }
    return false;
  }

  @override
  notifyTaskObservers(String notification) {
    for(var observer in _observers) {
      if(observer!= null) {
        if (notification == ISUtilsGeneral.formListUpdated) {
          observer.formListUpdated();
        }
        if (notification == ISUtilsGeneral.formRequestReloaded) {
          observer.requestFormReload();
        }
        if (notification == ISUtilsGeneral.claimListUpdated) {
          observer.claimListUpdated();
        }
        if(notification == ISUtilsGeneral.messageListUpdated){
          observer.messageListUpdated();
        }
        if(notification == ISUtilsGeneral.channelListUpdated){
          observer.channelListUpdated();
        }
      }
    }
  }
}

