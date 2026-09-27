# Contributing to the Get_Time_Ago Package

We appreciate your interest in contributing to the Get_Time_Ago Package built with Dart. By
contributing, you help make this project better and more accessible for others. Please take a moment
to review the following guidelines to ensure a smooth and collaborative development process.

## Code of Conduct

Please review and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). We expect all contributors to
be respectful, considerate, and inclusive when interacting with the project and its community.

## How to Contribute

Here are the steps to contribute to this project:

1. Fork the Repository: Click the "Fork" button at the top right of this repository to create a copy
   in your GitHub account.

2. Clone the Repository: Clone your forked repository to your local machine using the following
   command:

   ```bash
   git clone https://github.com/nixrajput/get_time_ago.git
   ```

3. Create a Branch: Create a new branch for your contributions. Make sure to choose a descriptive
   branch name that reflects the changes you intend to make.

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. Make Changes: Implement your changes and improvements in your local repository. Follow the coding
   style and best practices of the project.

5. Test Your Changes: Ensure that your changes do not introduce any errors or regressions. Test the
   website locally to verify that it functions as expected.

6. Commit Changes: Commit your changes with a clear and descriptive commit message.

   ```bash
   git commit -m "Add feature/fix: Describe your changes here"
   ```

7. Push Changes: Push your changes to your forked repository on GitHub.

   ```bash
   git push origin feature/your-feature-name
   ```

8. Create a Pull Request: Go to the original repository on GitHub and click the "New Pull Request"
   button. Provide a concise description of your changes, why they are necessary, and any relevant
   information.

9. Review and Collaboration: Contributors and maintainers will review your Pull Request. Be prepared
   to address any feedback or make additional changes as necessary.

10. Merge: Once your Pull Request is approved and passes all checks, a maintainer will merge it into
    the main branch. Congratulations, your contribution is now part of the project!

## Development Guidelines

- Follow the project's coding style and guidelines.
- Write clear and concise code with comments where necessary.
- Test your changes thoroughly before submitting a Pull Request.
- Keep Pull Requests focused on a single feature or bug fix.
- Be responsive to feedback and be willing to make improvements as requested.

## Adding or fixing a locale

Each locale is a table in `lib/src/locales/<code>.dart`, registered in `lib/src/locales/registry.dart`. Long-style wording for the second, minute, hour and day of the 2.x locales lives in those files; every short and narrow string, and every week, month and year string, is generated from CLDR.

- To pick up a newer CLDR release, bump `version` in `tool/cldr/generate.dart` and run `dart run tool/cldr/generate.dart --fetch`, then read what `test/cldr_parity_test.dart` reports. Never edit `lib/src/locales/cldr/*.g.dart` by hand.
- If a CLDR string itself is wrong, add the correction to `errata` in the generator and regenerate. The parity test flags it for removal once CLDR fixes it.
- To add a locale CLDR covers, add it to `cldrIds` in the generator, write a `lib/src/locales/<code>.dart` that uses the generated tables, and register it.
- Every change to wording needs a test in `test/get_time_ago_test.dart`, and a change to a 2.x string must also update `changed` in `test/golden/v2_parity_test.dart` with the reason.
- Occitan contributions are especially welcome: CLDR has no Occitan relative-time data, so Occitan has no weeks, months, years or short styles yet.

## Reporting Issues

If you encounter any issues or bugs while using the Get_Time_Ago Package, please report them on
the [Issues](https://github.com/nixrajput/get_time_ago/issues) page of the repository. Provide as
much detail as possible to help us understand and address the problem.

## Thank You

Thank you for contributing to the Get_Time_Ago Package project. Your contributions help make this
project better and more valuable to its users. We appreciate your time and effort in making this
project a success!
