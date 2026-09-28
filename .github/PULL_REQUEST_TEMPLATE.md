## Summary

<!-- What does this PR do? One paragraph is enough. -->

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Refactor / code cleanup
- [ ] Documentation
- [ ] CI / tooling
- [ ] Dependency update

## Related issues

Closes #<!-- issue number -->

## How to test

<!-- Steps for a reviewer to verify the change manually. -->

1.
2.

## Verification checklist

- [ ] `dart format --output=none --set-exit-if-changed .` - clean
- [ ] `dart analyze` - 0 issues
- [ ] `dart test` - all tests pass
- [ ] `dart pub publish --dry-run` - no warnings
- [ ] `pubspec.yaml` version bumped (required to merge)
- [ ] `CHANGELOG.md` has an entry for that version (`dart pub publish --dry-run` fails without one, so the release workflow stops)
- [ ] Docs updated where applicable (README, dartdoc comments)
- [ ] Locale text changed? Golden fixture or CLDR snapshot updated, never hand-edited
- [ ] `SECURITY.md` supported-versions table still correct
- [ ] No unrelated changes included in this PR
