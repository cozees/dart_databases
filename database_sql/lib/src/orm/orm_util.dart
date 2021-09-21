// Utility helper for orm generator

/// Helper class to provide utility for [DateTime] class.
class DateTimeUtil {
  /// [now] can be use as default value for column annotation which produce current local date and time.
  static DateTime now() => DateTime.now();

  /// [nowUtc] can be use as default value for column annotation which produce utc date and time.
  static DateTime nowUtc() => DateTime.now().toUtc();
}
