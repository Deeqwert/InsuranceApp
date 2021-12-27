import 'package:intl/intl.dart';
class ISUtilsDate {

  static DateTime? getDateTimeFromStringWithFormat(String? value, String? format, [bool timeZone = false]) {
    if (value == null || value == "") return null;
    final strFormat = format ?? ISEnumDateTimeFormat.MMddyyyy_hhmma.value;
    final df = DateFormat(strFormat, "en_US");
    final DateTime? date = df.parse(value, timeZone);  // Dec 22,2021
    return date;
  }

  static String getStringFromDateTimeWithFormat(DateTime? dateTime, String? format, [bool timeZone = false]) {
    if (dateTime == null) return "";
    final strFormat = format ?? ISEnumDateTimeFormat.MMddyyyy_hhmma.value;
    final df = DateFormat(strFormat, "en_US");
    return df.format(dateTime);
  }

  static int getDaysBetweenTwoDates(DateTime firstDate, DateTime secondDate){
    return 00;
  }

  static DateTime addDaysToDate(DateTime date, int days) {
    if (days < 0) {
      date.subtract(Duration(days: days.abs()));
    } else {
      date.add(Duration(days: days.abs()));
    }
    return date;
  }

  static DateTime getDateTimeFromMongoObjectId(String objectId) {
     return new DateTime.now();
  }

  static DateTime addHoursToDate(DateTime date, int hours) {
    return new DateTime.now();
  }

  static bool isSameDate(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    final String dateString1 = getStringFromDateTimeWithFormat(
        date1, ISEnumDateTimeFormat.yyyyMMdd.value, false);
    final String dateString2 = getStringFromDateTimeWithFormat(
        date2, ISEnumDateTimeFormat.yyyyMMdd.value, false);

    return dateString1 == dateString2;
  }

}

enum ISEnumDateTimeFormat {
  yyyyMMdd_HHmmss_UTC, // 1989-03-17T11:00:00.000Z
  yyyyMMdd_HHmmss, // 1989-03-17T11:00:00
  yyyyMMdd, // 1989-03-17
  MMddyyyy_hhmma, // 03-17-1989 02:00 AM
  MMddyyyy, // 03-17-1989
  MMdd, // 03/17
  EEEEMMMMdyyyy, // Friday, March 17, 1989
  MMMdyyyy, // Mar 17, 1989
  MMMMdd, // March 17
  hhmma,
  hhmm,// 02:00 AM
  hhmma_MMMd,
  MMMdyyyy_hhmma// 02:00 AM, Mar 17
}

extension DateTimeFormatExtension on ISEnumDateTimeFormat {
  String get value {
    switch (this) {
      case ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC:
        return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
      case ISEnumDateTimeFormat.yyyyMMdd_HHmmss:
        return "yyyy-MM-dd'T'HH:mm:ss";
      case ISEnumDateTimeFormat.yyyyMMdd:
        return "yyyy-MM-dd";
      case ISEnumDateTimeFormat.MMddyyyy_hhmma:
        return "MM-dd-yyyy hh:mm a";
      case ISEnumDateTimeFormat.MMddyyyy:
        return "MM-dd-yyyy";
      case ISEnumDateTimeFormat.MMdd:
        return "MM/dd";
      case ISEnumDateTimeFormat.EEEEMMMMdyyyy:
        return "EEEE, MMMM d, yyyy";
      case ISEnumDateTimeFormat.MMMdyyyy:
        return "MMM d, yyyy";
      case ISEnumDateTimeFormat.MMMMdd:
        return "MMMM dd";
      case ISEnumDateTimeFormat.hhmma:
        return "hh:mm a";
      case ISEnumDateTimeFormat.hhmm:
        return "hh:mm";
      case ISEnumDateTimeFormat.hhmma_MMMd:
        return "hh:mm a, MMM d";
      case ISEnumDateTimeFormat.MMMdyyyy_hhmma:
        return "MMM d, yyyy @ hh:mm a";
      default:
        return "";
    }
  }
}
