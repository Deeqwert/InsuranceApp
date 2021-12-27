import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as location;
import 'package:insurance/isModel/claim/dataModel/is_struct_coord.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:location/location.dart' as location_manager;

class LCLocationManager {
  static LCLocationManager sharedInstance = LCLocationManager();
  double lat = 0.0001;
  double lng = 0.0001;
  location_manager.Location? locationManager;


  ISStructCoord get geo{
    final ISStructCoord point = ISStructCoord();
    point.fLongitude=lat;
    point.fLongitude = lng;
    return point;
  }

  initializeLocationManager() {
    ISUtilsGeneral.log("LocationManager initialized");
    locationManager ??= location_manager.Location();
    startUpdatingLocation();
  }

  startUpdatingLocation() {
    // Request permission to use location
    locationManager!.requestPermission().then((permissionStatus) {
      if (permissionStatus == location_manager.PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        locationManager!.onLocationChanged.listen((locationData) {
          lat = locationData.latitude!;
          lng = locationData.longitude!;
        });
      }
    });
  }

  location.Location getBestLocationForPlaceAutocomplete() {
    location.Location centralPoint =
    location.Location(lat: 40.3468578, lng: -82.6310666);
    location.Location currentPoint = location.Location(lat: lat, lng: lng);

    const double maximumOffset = 214000.0; // meters
    final distance = centralPoint.distanceTo(currentPoint);
    if (distance > maximumOffset) {
      return centralPoint;
    }
    return currentPoint;
  }

  bool checkArrivalProbability(LatLng toCoordinates) {
    location.Location currentLocation = location.Location(lat: lat, lng: lng);

    location.Location destinationLocation = location.Location(
        lat: toCoordinates.latitude, lng: toCoordinates.longitude);

    final distanceInMeters = destinationLocation.distanceTo(currentLocation);
    return distanceInMeters < 100;
  }
}

extension LocationExenstion on location.Location {
  double distanceTo(location.Location dest) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(lat! - dest.lat!);
    var dLon = _toRadians(lng! - dest.lng!);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(lat!)) *
            cos(_toRadians(dest.lng!));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }
}
