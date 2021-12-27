class ISStructCoord {
  double fLatitude = 0.0;
  double fLongitude = 0.0;

  ISStructCoord({double latitude = 0.0, double longitude = 0.0}) {
    fLatitude = latitude;
    fLongitude = longitude;
  }

  bool isValid() {
    return !(fLatitude == 0.0 && fLongitude == 0.0);
  }
}
