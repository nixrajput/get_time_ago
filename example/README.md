# get_time_ago example

## Usage

```dart
import 'package:get_time_ago/get_time_ago.dart';

void main() {
  final posted = DateTime.now().subtract(const Duration(minutes: 5));

  print(GetTimeAgo.parse(posted)); // 5 minutes ago
  print(GetTimeAgo.parse(posted, locale: 'fr')); // il y a 5 minutes

  const narrow = GetTimeAgo(style: TimeAgoStyle.narrow, maxUnit: TimeUnit.year);
  print(narrow.format(posted)); // 5m ago
  print(narrow.nextChange(posted)); // how long until the text changes
}
```

## The demo app

This directory is also a Flutter demo of every `GetTimeAgo` option: locale, style, largest unit and date pattern. It has three parts:

- **Try it:** a slider that scrubs a moment across four years, showing the text in all three styles at once.
- **Samples:** fixed offsets, formatted against a frozen clock so each row stays exact.
- **Live:** a row refreshed through `nextChange` instead of a ticking timer.

The preview never scrolls away. On wide or landscape screens the options and preview are both pinned side by side, whenever the options fit whole, with the rest in one list beneath. On a portrait phone the preview is pinned above that list, and the options lead it. A mouse wheel anywhere on the page scrolls the list. The app follows the device theme, and the switch in the app bar forces light or dark.

`flutter test` checks the layout at phone to desktop sizes, including a large text scale and a phone's bottom inset.

Run it from this directory with `flutter run -d chrome`, or open the live demo at https://nixrajput.github.io/get_time_ago.
