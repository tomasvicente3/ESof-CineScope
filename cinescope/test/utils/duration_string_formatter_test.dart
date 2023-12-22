import 'package:cinescope/utils/duration_string_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("DurationStringFormatter", () { 
    test(" works correctly", () {
      expect(const Duration(seconds: 1).toFormattedString("{}", "{}"), "1 second");
      expect(const Duration(seconds: 2).toFormattedString("{}", "{}"), "2 seconds");
      expect(const Duration(seconds: 59).toFormattedString("{}", "{}"), "59 seconds");
      expect(const Duration(minutes: 1).toFormattedString("{}", "{}"), "1 minute");
      expect(const Duration(minutes: 2).toFormattedString("{}", "{}"), "2 minutes");
      expect(const Duration(minutes: 59).toFormattedString("{}", "{}"), "59 minutes");
      expect(const Duration(hours: 1).toFormattedString("{}", "{}"), "1 hour");
      expect(const Duration(hours: 2).toFormattedString("{}", "{}"), "2 hours");
      expect(const Duration(hours: 23).toFormattedString("{}", "{}"), "23 hours");
      expect(const Duration(days: 1).toFormattedString("{}", "{}"), "1 day");
      expect(const Duration(days: 2).toFormattedString("{}", "{}"), "2 days");
      expect(const Duration(days: 6).toFormattedString("{}", "{}"), "6 days");
      expect(const Duration(days: 8).toFormattedString("{}", "{}"), "1 week");
      expect(const Duration(days: 14).toFormattedString("{}", "{}"), "2 weeks");
      expect(const Duration(days: 15).toFormattedString("{}", "{}"), "2 weeks");


















    });
  });
}