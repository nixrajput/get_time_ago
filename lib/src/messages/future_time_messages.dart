/// Optional mixin for locale-specific future relative time formatting.
///
/// Bundled locales use this mixin to provide translated prefixes/suffixes
/// (e.g. `in 5 minutes`, `dans 5 minutes`). Custom locales can mix this in
/// without changing the core [Messages] interface.
mixin FutureTimeMessages {
  /// Prefix added before a future relative time message.
  /// Example: `in` or `` (empty).
  String prefixFromNow() => 'in';

  /// Suffix added after a future relative time message.
  /// Example: `from now` or `` (empty).
  String suffixFromNow() => '';
}
