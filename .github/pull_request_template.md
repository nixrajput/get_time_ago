# Pull Request Checklist

## What does this PR do?

<!-- **Please provide a clear and concise description of the changes in this PR.** Example: -->

<!--

- Adds/improves functionality for localized time-ago formatting
- Fixes bugs or issues
- Adds new features like custom time thresholds, additional languages, etc.
- Optimizes performance or enhances accessibility

-->

## **Checklist**

### Code Changes

- [ ] I have added new features to the package (e.g., custom time thresholds, new languages, etc.)
- [ ] I have fixed existing issues (e.g., incorrect formatting, performance bottlenecks)
- [ ] I have improved the overall structure or optimized the codebase

### Documentation

- [ ] I have updated the README file or relevant documentation with the changes
- [ ] I have added code usage examples or updated existing examples to reflect changes
- [ ] I have updated the package version in the `pubspec.yaml` file

### Testing

**General Tests**

- [ ] The package correctly formats time differences into human-readable strings
- [ ] The package supports dynamic updates (e.g., changing locales, thresholds)

**Localization**

- [ ] The package supports all documented languages
- [ ] Custom locales can be added and work as expected
- [ ] Language fallback works correctly if a specific locale is missing

**Custom Thresholds**

- [ ] Custom time thresholds are applied correctly
- [ ] The package handles edge cases like just now, future dates, or extreme past dates

**Error Handling**

- [ ] The package handles null or invalid inputs gracefully
- [ ] Fallback behavior works for unexpected or incorrect configurations

**Responsiveness**

- [ ] The package adapts to time-zone differences accurately
- [ ] The formatting responds correctly to locale changes in the app

**Performance**

- [ ] The package performs efficiently, even when processing frequent or large updates
- [ ] Performance tests show no regressions

### How did you verify your code works?

<!-- **Please explain how you tested the code changes.** Example: -->

<!--

- I have written unit tests covering the new features
- I ran manual tests to verify time formatting for different locales and thresholds
- I tested with various configurations (custom thresholds, language overrides)
- All tests pass locally (`flutter test`)

-->
