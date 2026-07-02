import 'package:get_time_ago/get_time_ago.dart';

class CustomLocaleTestMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => 'ago';

  @override
  String justNow(int seconds) => 'now';

  @override
  String secsAgo(int seconds) => '$seconds secs';

  @override
  String minAgo(int minutes) => 'a min';

  @override
  String minsAgo(int minutes) => '$minutes mins';

  @override
  String hourAgo(int minutes) => 'an hr';

  @override
  String hoursAgo(int hours) => '$hours hrs';

  @override
  String dayAgo(int hours) => 'a d';

  @override
  String daysAgo(int days) => '$days ds';

  @override
  String wordSeparator() => ' ';
}
