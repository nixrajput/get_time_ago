# AI Agent Guidelines

Last updated: 2026-10-07

---

## Project

**get_time_ago** formats a `DateTime` as relative time ("just now", "5 minutes ago", "in 3 days") in 22 locales. It is pure Dart on purpose: no Flutter dependency, so the same package serves a Flutter app, a Dart backend and a CLI. A Flutter widget is planned as a separate package, `get_time_ago_widget`. Never add one here.

| Area          | Detail                                                                                                                 |
| ------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Language      | Dart 3, pure Dart, SDK `^3.13.0`                                                                                       |
| Runtime deps  | one: `intl` at `>=0.19.0 <0.21.0`, covering Flutter 3.47's `intl ^0.20.3` requirement                                  |
| Tests         | `package:test` on an injected clock, a golden against 2.4.1, a parity test against pinned CLDR, a README snippet guard |
| Lint / format | `package:lints` recommended, plus `avoid_print` and `public_member_api_docs`                                           |
| Publishing    | pub.dev, tag-triggered via the `PUB_RELEASE_TOKEN` secret                                                              |

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
  readme_test.dart                 README TOC, links, claim counts, and every Dart block found in readme_snippets.dart
```

### The checks

`dart format --output=none --set-exit-if-changed .`, `dart analyze`, `TZ=Asia/Kolkata dart test`, `(cd example && flutter test)`, `dart pub publish --dry-run`. CI's `build` job runs the first four, plus the tests again in a browser (`dart test -p chrome`, then with `-c dart2wasm`) and a 100% coverage gate (`scripts/coverage.sh 100`). The `floor` job repeats analyze and test on Dart 3.13.0, the SDK floor. The tests run in a non-UTC zone because UTC dates must render in local time. `.githooks/pre-push` runs them too (`git config core.hooksPath .githooks`). On every PR to `master`, `example.yml` builds the example app for Android, iOS, macOS, Windows, Linux and web (JS and Wasm). The example's native icons come from `example/assets/icon` via `cd example && dart run flutter_launcher_icons`.

### Conventions

- Conventional Commits, imperative subject `<=` 50 chars, no trailing period, no `Co-Authored-By` or `Generated with` trailers.
- Every PR that changes anything users receive bumps `pubspec.yaml` and adds a matching `CHANGELOG.md` entry. CI gate `version bumped` enforces both, and without the entry `dart pub publish --dry-run` fails, which stops the release workflow before it publishes.
- The PR title becomes the squash commit message.
- `master` is protected: PR required, squash-only merges.
- The README documents **shipped features only** - no roadmap, no plans. Every Dart block in it, except the `// 2.x` one showing the old API (which cannot compile), must also be in `test/readme_snippets.dart`, verbatim, or `readme_test.dart` fails. Link repository files by absolute GitHub URL, because pub.dev drops relative links. `readme_test.dart` checks this.
- Markdown prose is never hard-wrapped: one line per paragraph and per list item. Do not re-wrap these files to a column.
- Never use an em-dash. Use a hyphen.

### Things that will bite you

- **Elapsed time is rounded once**, in `roundSeconds`. Do not reintroduce `Duration.inX` truncation: it turned "in 60 seconds" into "in 59 seconds".
- **`Plural.select` keeps intl's explicit-number cases on.** An exact count of 1 must reach `one` even where CLDR has no `one` category, which is how Korean keeps `일분`. Turning them off would also be wrong the other way. With them on, a table must hold only the categories that its language uses. Otherwise a count of 2 hits `two` in languages that have none.
- **Const maps reject duplicate keys, even through spreads.** A generated `LongUnits` map must never contain a unit that its hand-written locale file also defines. `longUnitsFor` in `tool/cldr/generate.dart` owns that split.
- **Never hand-edit `lib/src/locales/cldr/*.g.dart` or `test/golden/v2_outputs.json`.** For a CLDR update, bump `version` in `tool/cldr/generate.dart`, run `dart run tool/cldr/generate.dart --fetch`, and read the parity test's diff. A wrong CLDR string goes in the generator's `errata`, whose guard test fails once CLDR fixes it.
- **`oc` is skipped by name**, because CLDR's Occitan data is its root locale's placeholders. The parity test fails the day that changes, which is the cue to generate it.
- **`fa` and `ur` strings start with U+202B**, kept byte-for-byte from 2.x. The generator and the locale files write it as `\u{202b}` so it stays visible.
- **Unknown locales must never throw at format time.** Apps pass device locales straight in.
- **Never guard with `assert`.** Release builds strip it.
- **The golden's `date` keys assume the latest intl 0.20.x.** intl 0.19.0 ships older CLDR date symbols, so a stale `pubspec.lock` makes them fail. Run `dart pub upgrade`.
- **After `dart pub downgrade`, `dart test` cannot load any test on the Dart 3.13 floor.** Every `test_core` allows `frontend_server_client >=3.2.0`, and 3.2.0 looks for `frontend_server.dart.snapshot`, which the 3.13 SDK no longer ships. Analysis still passes, and analysis is all that pana's lower-bound check runs. Run `dart pub upgrade` before you test again.

---

## Always-Active Instructions

> These apply to EVERY interaction, automatically.

### Writing Style

Never use em-dashes (`—`). Always use a hyphen (`-`) instead - in code comments, commit messages, PR/issue text, chat responses, and any file content.

#### Plain technical English (adapted from ASD-STE100)

Write text that has exactly one reading. The goal is to remove ambiguity, not words. Stop when a sentence cannot be misread, not when it is shortest.

**Everywhere** (chat, commits, PR and issue text, docs, code comments). Aim for about 80% of strict STE. Follow these rules, but treat the word limits as targets and skip the strict-mode extras.

- Active voice. Name who acts: "The job deletes the file", not "The file is deleted". Use passive only when the actor is unknown or irrelevant.
- One idea per sentence. Aim for 20 words or fewer in instructions and 25 or fewer in descriptions.
- No semicolons in prose. Where a semicolon or a dash would join two clauses, prefer two sentences.
- Use a numbered or bulleted list for 3+ steps, conditions or options. Keep one topic and 6 sentences max per paragraph.
- One name per thing. Pick one term (e.g. "user" or "account", not both) and keep it for the whole text. Rotating synonyms makes the reader ask if they are different things.
- One meaning and one part of speech per word. If "store" names a storage layer, do not also use it to mean "save".
- Plain words, not formal ones: use, start, before, about, to, make sure - not utilize, leverage, commence, prior to, approximately, in order to, ensure.
- Verbs, not nominalizations: "analyze the log", not "perform an analysis of the log".
- Plain verbs, not soft phrasal verbs: start, contact, read, begin - not spin up, reach out, dive into, kick off.
- No marketing adjectives (seamless, robust, powerful, blazing-fast, effortless). Delete them or give the number that earns the claim.
- No hedge stacking ("it is worth noting that this may potentially help"). State the claim or cut it.
- Keep subjects, verbs and articles. Do not drop words to save space ("Files not backed up will be lost" - which files?).
- Noun stacks of 3 words max: "the handler that sets task-queue priority", not "the agent task queue priority handler".
- Define a domain term once, on first use, if it is not common English.
- Label a risky step WARNING (irreversible: data loss, money, production, real users) or CAUTION (recoverable). Give the command first, then the risk: "WARNING: Do not run this on production. It deletes all sessions."

**Keep modality. Confidence is content.** "May have failed" never becomes "failed". "Could be caused by X" never becomes "X is the cause". Never upgrade a hedge to a fact, and never add a cause, frequency or mechanism the evidence does not show. Never drop a condition, exception or scope qualifier to shorten a sentence. If a rule would cost precision, keep the longer wording. When you rewrite someone else's text, name any content you added.

**Strict mode** applies to text that an agent or program reads with no human to resolve ambiguity. That includes AGENTS.md, CLAUDE.md, skills, agent and subagent prompts, tool descriptions, hook output, error and log messages, and reports that one agent writes for another.

- The 20/25-word limits are hard caps. One instruction per sentence, unless two actions happen at the same time.
- Write instructions in the imperative. Keep descriptions as descriptions. Do not turn a fact into a command.
- Put the condition first: "If the app is uninstalled, skip the sync." Do not put it at the end.
- Use one verb for one action in the whole file. Do not mix "check", "verify" and "confirm" for the same action. If "check" is already a noun in the file (a CI check), use "verify" for the action.
- Use simple tenses by default: "the job completed", not "the job is completing". Keep a compound form only when it carries meaning: "is running" (still in progress), "has completed" (done and available now), "may have failed" (uncertain). When tense and modality conflict, modality wins.

**Exempt:** creative or persuasive copy, code, and quoted or verbatim text (error strings, the user's words).

**Pick the format before the words.** Some explanations cover a flow, a structure or 3+ interacting parts. For these, draw a diagram (ASCII in chat) or offer an HTML page instead of a long block of text.

These rules fix form, not substance. Leave text that already follows them unchanged. If a paragraph has nothing to say, delete it instead of polishing it.

### Working Discipline

#### 1. Understand Before Acting

**Reach 95% certainty about what the user wants before you write code, a plan or a design. Below that bar, ask.**

**The 95% gate**

- Before you start, state in one or two concrete sentences what "done" looks like. If you cannot, you are below the bar. Ask.
- Ask all clarifying questions in one batch, up front. Do not spread them across turns, one question at a time.
- Ask only questions whose answers change the outcome. If an answer would not change what you build, pick the sensible default, name it and continue.
- A question costs one message. Building the wrong thing costs the whole implementation. Never trade a question for a guess.
- Skip the gate only for trivial, reversible, unambiguous work: a typo, a rename, a one-line fix, a command given verbatim.
- The gate applies BEFORE you start. When the task is clear, execute it end to end. Do not stop mid-flow to ask approval for steps that the request already implies.

**Map the blast radius**

- Before you start, find every place that depends on what you will change. The request names one surface. Shared logic, shared data and shared formats usually feed several.
- Trace it. Do not guess. Grep every caller, reader, subscriber and consumer of the function, field, rule, default, format or schema that you change.
- Look past the screen in front of you. Look for:
  - other views of the same data
  - exports and reports
  - background jobs and schedulers
  - public APIs and webhooks
  - caches and derived or stored state
  - permissions, analytics, tests and docs
- Give the user the list of dependents that you found. Ask which of them must change with your change, and which must keep their current behavior exactly. Ask this in the same up-front batch as your other questions, not after you start.
- If you cannot check what a consumer expects, say so. Do not silently change its behavior, and do not silently keep it.
- Record the affected areas in the plan, ticket and PR description. Reviewers and QA use this record to know what to test again.
- A map of the impact does not give permission to widen the change. Rule 3 still applies: report what is affected, and edit only what the user's answer says to edit.

**No unverified assumptions**

- An assumption is anything without evidence: you did not read it, did not run it, and nobody told you. Treat it as unknown, not as "probably fine".
- Valid evidence is:
  - the actual code, schema, config or migration
  - a command that you ran, and its output
  - docs for the exact version in use
  - the user's own words
- These are NOT evidence: a file or function name, "this is how these projects usually work", or memory of a similar codebase.
- Read the real implementation of anything that you call, extend, override or depend on. A signature or a name does not show behavior.
- Treat second-hand claims as unverified: stale comments, outdated docs, a subagent's summary, a review bot's finding, an old ticket. Check each claim against the current code before you act on it.
- If you must continue without evidence, say so openly: "Assuming X because I could not check Y." Never leave an assumption silent.
- Never call something done, fixed, working or passing unless you ran the check and saw it pass. Show the output.

**Before you implement**

- Read the existing code and follow its patterns. Do not invent new ones.
- If the request has more than one reasonable reading, present all readings. Do not silently pick one.
- If a simpler approach exists, say so. Disagree when you have a reason.
- If something is unclear, stop and name exactly what is unclear.

#### 2. Simplicity First

**Write the minimum code that solves the problem. Write nothing speculative.**

- No features beyond the request.
- No abstractions for code with one use.
- No "flexibility" or "configurability" that the user did not request.
- No error handling for impossible scenarios.
- If you write 200 lines and 50 lines can do the same work, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

#### 3. Surgical Changes

**Change only what you must. Remove only the mess that you made.**

When you edit existing code:

- Do not "improve" adjacent code, comments or formatting.
- Do not refactor code that works.
- Match the existing style, even if you would write it differently.
- If you see unrelated dead code, mention it. Do not delete it.

When your changes create orphans:

- Remove the imports, variables and functions that YOUR changes made unused.
- Do not remove dead code that existed before your change, unless the user asks.

The test: every changed line traces directly to the user's request.

#### 3a. Code Comments

**Comment the why and the how, never the what. Most code needs no comment.**

- Code shows what it does. Add a comment only when the why or the how is hard to follow. Examples: non-obvious logic, a deliberate tradeoff, or a constraint that the code cannot show.
- Do NOT add routine comments on methods, classes, variables, props, components or PropTypes. Prop-type and type comments are noise, except for a special case or an explicit user request.
- Write a comment only if it does one of these:
  - prevents a real misunderstanding
  - marks significant or surprising behavior
  - documents a cross-file side effect: a hook, mutation or edit in one file that changes another file. These cross-file couplings ARE worth a comment.
- Length: 3 lines max, 120 characters max per line. Prefer one line. If one line cannot hold it, ask yourself if the comment is necessary.
- When you edit existing code, do not add comments that the user did not ask for just to "explain" your change. The diff and the commit message carry that.
- Such comments are the most common drift. A one-line fix does NOT need a comment that says why it is correct or what the old code did wrong.
- Default to ZERO comments on a change. The exceptions are a genuine cross-file coupling, a non-obvious constraint, or surprising behavior that would confuse a future reader. When in doubt, add no comment.
- Comments are for non-obvious handling in a method, class, library integration or cross-file side effect. They are not for variables, props, local assignments, or a restatement of what the code plainly does.

#### 4. Goal-Driven Execution

**Define success criteria. Repeat until the check passes.**

Change each task into a goal that you can check:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Make sure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → check: [how]
2. [Step] → check: [how]
3. [Step] → check: [how]
```

Strong success criteria let you repeat the loop without help. Weak criteria ("make it work") need constant clarification.

#### 5. Report What Was Done

When the work is complete, state what changed and why. Do not only say that it is done.

---

**These guidelines work if** diffs have fewer unnecessary changes, fewer rewrites come from overcomplication, and clarifying questions come before implementation, not after mistakes.

---

### Multi-Agent Safety Rules

- **Never** create, apply or drop git stash entries, unless the user explicitly asks.
- **Never** edit files in `node_modules/`, `vendor/` or other dependency directories.
- **Always** work on a dedicated branch when concurrent agents run.
- **Never** force-push or rebase shared branches from an agent session.
- **Check** that no other agent is changing the same files before you change them.

### Release Safety

- WARNING: **Never** merge a PR or publish to pub.dev without explicit approval. A merge to `master` triggers the tag and the pub.dev publish in one shot. A published version number can never be reused or unpublished.
- A publish run can exit non-zero **after** it publishes successfully. A red Publish check means "check pub.dev for the version", not "it failed".

---
