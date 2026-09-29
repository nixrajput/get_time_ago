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

The preview never scrolls away. The options sit in cards that open and close, and a closed card shows its current values, so a phone starts with an overview of everything. From 840 pixels wide, and on a landscape phone, the options get a scrolling panel beside the preview, with the rest of the demo scrolling under the preview; a narrower screen pins the preview above one list of cards. An open card's header stays pinned while the card is on screen, Reset puts every option back, and Expand all opens every card in a group. A mouse wheel over the preview scrolls the list beside or under it. The app follows the device theme, and the switch in the app bar forces light or dark.

`flutter test` checks the layout at 19 screen sizes, from a 320-pixel phone to a 3440-pixel ultrawide and including 200% text, and that cards open by tap and keyboard, focus is never hidden behind a pinned header and the page keeps its state across a resize.

Run it from this directory with `flutter run -d chrome`, or open the live demo at https://nixrajput.github.io/get_time_ago.
