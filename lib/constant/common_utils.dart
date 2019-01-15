class CommonUtils {
  static String formatTime(String oriTime) {
    DateTime dateTime = DateTime.parse(oriTime);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
