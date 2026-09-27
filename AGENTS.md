# AI Agent Guidelines

Last updated: 2026-09-27

---

## Project

**get_time_ago** formats a `DateTime` as relative time ("just now", "5 minutes ago", "in 3 days") in 22 locales. It is pure Dart on purpose: no Flutter dependency, so the same package serves a Flutter app, a Dart backend and a CLI. A Flutter widget is planned as a separate package, `get_time_ago_widget`; never add one here.

| Area          | Detail                                                                                         |
| ------------- | ---------------------------------------------------------------------------------------------- |
| Language      | Dart 3, pure Dart, SDK `^3.8.0`                                                                |
| Runtime deps  | one: `intl`, kept at `>=0.19.0 <0.21.0` because `flutter_localizations` pins it exactly        |
| Tests         | `package:test` on an injected clock; a golden against 2.4.1; a parity test against pinned CLDR |
| Lint / format | `package:lints` recommended, plus `avoid_print` and `public_member_api_docs`                   |
| Publishing    | pub.dev, tag-triggered via the `PUB_RELEASE_TOKEN` secret                                      |

### Layout

```
lib/
  get_time_ago.dart                public barrel
  src/
    get_time_ago.dart              GetTimeAgo: format, nextChange, defaults, registry facade
    time_unit.dart                 TimeUnit, TimeAgoStyle
    elapsed.dart                   pure arithmetic: rounding, unit selection, change points
    messages/                      TimeAgoMessages contract; TimeAgoLocale table, Plural, Numerals
    locales/                       one const table per locale, plus registry.dart (lookup, aliases)
    locales/cldr/                  generated from CLDR by tool/cldr/generate.dart; never hand-edit
tool/cldr/                         the generator and the vendored CLDR 48.2.2 snapshot (dev-only)
test/
  golden/                          2.4.1 outputs and the parity test that pins them
```

### The checks

`dart format --output=none --set-exit-if-changed .`, `dart analyze`, `TZ=Asia/Kolkata dart test`, `dart pub publish --dry-run`. CI runs the first three plus a 90% coverage gate in the `build` job; the test step runs in a non-UTC zone because UTC dates must render in local time. `.githooks/pre-push` runs them too (`git config core.hooksPath .githooks`). `example.yml` builds the example app for Android, iOS, macOS, Windows, Linux and web (JS and Wasm) on every PR; the example's native icons come from `example/assets/icon` via `dart run flutter_launcher_icons`.

### Conventions

- Conventional Commits, imperative subject `<=` 50 chars, no trailing period, no `Co-Authored-By` or `Generated with` trailers.
- Every PR that changes anything users receive bumps `pubspec.yaml` and adds a matching `CHANGELOG.md` entry. CI gate `version bumped` enforces both, and pub.dev rejects a publish with no changelog entry.
- The PR title becomes the squash commit message.
- `master` is protected: PR required, squash-only merges.
- The README documents **shipped features only** - no roadmap, no plans.
- Markdown prose is never hard-wrapped: one line per paragraph and per list item. Do not re-wrap these files to a column.
- Never use an em-dash. Use a hyphen.

### Things that will bite you

- **Elapsed time is rounded once**, in `roundSeconds`. Do not reintroduce `Duration.inX` truncation: it turned "in 60 seconds" into "in 59 seconds".
- **`Plural.select` keeps intl's explicit-number cases on.** An exact count of 1 must reach `one` even where CLDR has no `one` category, which is how Korean keeps `일분`. Turning them off would also be wrong the other way: with them on, a table must hold only the categories its language uses, or a count of 2 hits `two` in languages that have none.
- **Const maps reject duplicate keys, even through spreads.** A generated `LongUnits` map must never contain a unit its hand-written locale file also defines; `longUnitsFor` in `tool/cldr/generate.dart` owns that split.
- **Never hand-edit `lib/src/locales/cldr/*.g.dart` or `test/golden/v2_outputs.json`.** For a CLDR update, bump `version` in `tool/cldr/generate.dart`, run `dart run tool/cldr/generate.dart --fetch`, and read the parity test's diff. A wrong CLDR string goes in the generator's `errata`, whose guard test fails once CLDR fixes it.
- **`oc` is skipped by name**, because CLDR's Occitan data is its root locale's placeholders. The parity test fails the day that changes, which is the cue to generate it.
- **`fa` and `ur` strings start with U+202B**, kept byte-for-byte from 2.x. The generator and the locale files write it as `\u{202b}` so it stays visible.
- **Unknown locales must never throw at format time.** Apps pass device locales straight in.
- **Never guard with `assert`.** Release builds strip it.
- **The golden's `date` keys assume the latest intl 0.20.x.** intl 0.19.0 ships older CLDR date symbols, so a stale `pubspec.lock` makes them fail; run `dart pub upgrade`.

---

## Always-Active Instructions

> These apply to EVERY interaction, automatically.

### Working Discipline

> Behavioral guidelines to reduce common LLM coding mistakes. Bias toward caution over speed; for trivial tasks, use judgment.

#### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- Read existing code and understand patterns before proposing changes.
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

#### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

#### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

#### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

#### 5. Report What Was Done

After completing work, state what changed and why - not just that it's done.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

### Multi-Agent Safety Rules

- **Never** create/apply/drop git stash entries unless explicitly requested
- **Never** edit files in `node_modules/`, `vendor/`, or other dependency directories
- **Always** work on a dedicated branch when running concurrent agents
- **Never** force-push or rebase shared branches from an agent session
- **Verify** no other agent is modifying the same files before making changes

### Release Safety

- **Never** merge a PR or publish to pub.dev without explicit approval. Merging `master` triggers the tag and the pub.dev publish in one shot, and a published version number can never be reused or unpublished.
- A publish run can exit non-zero **after** publishing successfully. A red Publish check means "check pub.dev for the version" rather than "it failed".

---
