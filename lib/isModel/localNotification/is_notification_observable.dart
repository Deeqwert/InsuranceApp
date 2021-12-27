import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
abstract class ISNotificationObservable {
  bool addObserver(ISNotificationObserver? o);
  bool removeObserver(ISNotificationObserver? o);
  removeAllObservers();
  notifyTaskObservers(String notification);
}
