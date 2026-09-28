# Contributing to get_time_ago

Thanks for your interest in contributing. get_time_ago turns a moment into relative time, such as "5 minutes ago", in 22 locales, and contributions that make that text more correct in more languages are very welcome.

## Code of Conduct

Please review and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). We expect all contributors to be respectful, considerate, and inclusive when interacting with the project and its community.

## Getting set up

Requires Dart 3.13 or newer (Flutter 3.47 or newer bundles it), and Flutter for the example app.

```bash
git clone https://github.com/nixrajput/get_time_ago.git
cd get_time_ago
flutter pub get
git config core.hooksPath .githooks   # optional: runs the checks below before each push
```

`flutter pub get` resolves the example app too.

## The checks

Every one of these must pass before a PR can merge. CI runs all of them but the publish dry run, which the release workflow runs before every publish:

```bash
dart format --output=none --set-exit-if-changed .
dart analyze
TZ=Asia/Kolkata dart test
dart test -p chrome                  # and again with -c dart2wasm
(cd example && flutter test)
dart pub publish --dry-run
```

The tests run in a non-UTC zone because UTC dates must render in local time. CI also holds line coverage at 90% (`scripts/coverage.sh 90`).

## Workflow

1. **Fork and branch.** Branch off `master` with a descriptive name (`feat/locale-sw`, `fix/ja-plural`).
2. **Write the test first.** Every feature and bugfix lands with a test. Bugs get a test that reproduces them before the fix.
3. **Keep the diff surgical.** Every changed line should trace to the change you are making. No drive-by refactors, no speculative abstractions.
4. **Bump the version.** `pubspec.yaml` must move in every PR, with a matching `CHANGELOG.md` entry - CI enforces both (`version bumped`). Patch for fixes, minor for features.
5. **Update the docs.** If behaviour a user can see changes, the README changes in the same PR.
6. **Open the PR.** Fill in the template. The PR title becomes the squash commit message on merge, so write it in Conventional Commit form (`feat: add Swahili`) and keep it under ~50 characters.

## Adding or fixing a locale

Each locale is a table in `lib/src/locales/<code>.dart`, registered in `lib/src/locales/registry.dart`. Long-style wording for the second, minute, hour and day of the 2.x locales lives in those files; every short and narrow string, and every week, month and year string, is generated from CLDR.

- To pick up a newer CLDR release, bump `version` in `tool/cldr/generate.dart` and run `dart run tool/cldr/generate.dart --fetch`, then read what `test/cldr_parity_test.dart` reports. Never edit `lib/src/locales/cldr/*.g.dart` by hand.
- If a CLDR string itself is wrong, add the correction to `errata` in the generator and regenerate. The parity test flags it for removal once CLDR fixes it.
- To add a locale CLDR covers, add it to `cldrIds` in the generator, write a `lib/src/locales/<code>.dart` that uses the generated tables, and register it.
- Every change to wording needs a test in `test/get_time_ago_test.dart`, and a change to a 2.x string must also update `changed` in `test/golden/v2_parity_test.dart` with the reason.
- Occitan contributions are especially welcome: CLDR has no Occitan relative-time data, so Occitan has no weeks, months, years or short styles yet.

## Conventions

- **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `ci:`, `chore:`, `refactor:`), imperative subject, no trailing period.
- **Style:** `dart format` and the lints in `analysis_options.yaml`, including `public_member_api_docs`: every public API element carries a doc comment.
- **Language:** Dart `^3.13.0`, pure Dart. No Flutter dependency, so the package runs on the VM, in Flutter apps and on the web.
- **Dependencies:** one runtime dependency, `intl`, for the full date. Please do not add another without discussing it in an issue first.
- **Comments:** explain why, not what. Most code needs none.

## Reporting issues

Bugs and feature requests go to [Issues](https://github.com/nixrajput/get_time_ago/issues) - the templates ask for the locale, the versions and a minimal repro, which is usually enough to act on. Questions and open-ended ideas belong in [Discussions](https://github.com/nixrajput/get_time_ago/discussions). Security issues follow [SECURITY.md](SECURITY.md) instead - never a public issue.

## Thank you

Every issue, repro, and PR makes this project more useful. Thanks for taking the time.
