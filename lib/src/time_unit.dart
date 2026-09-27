/// The units a relative time is expressed in, smallest first.
///
/// `GetTimeAgo.maxUnit` compares units by their order here.
enum TimeUnit {
  /// Seconds.
  second,

  /// Minutes.
  minute,

  /// Hours.
  hour,

  /// Days.
  day,

  /// Weeks of seven days.
  week,

  /// Months of thirty days.
  month,

  /// Years of 365 days.
  year,
}

/// How much room the text may take.
enum TimeAgoStyle {
  /// Full words, such as "5 minutes ago". Every locale has it.
  long,

  /// Abbreviated words from CLDR, such as "5 min. ago".
  short,

  /// The shortest CLDR form, such as "5m ago".
  narrow,
}
