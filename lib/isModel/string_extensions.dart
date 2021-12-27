extension BoolParsing on String {
  bool toBool() {
    return toLowerCase() == 'true';
  }

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String take(int n) {
    if (n > length) {
      return this;
    }
    return substring(0, n);
  }
}
