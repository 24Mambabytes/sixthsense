import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/providers/haptics_provider.dart';
import 'package:sixthsense/providers/text_to_speech_provider.dart';
import 'package:sixthsense/utils/strings.dart';

class Help extends ConsumerWidget {
  const Help({super.key});

  @override
  // Builds the widget tree for the `Help` screen.
  //
  // This function retrieves the arguments passed to the `Help` screen from the
  // `ModalRoute` and extracts the `title` from the arguments. It then uses the
  // `title` to set the title of the `AppBar` and displays the corresponding
  // text in the `body` of the `Scaffold`.

  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = args['title'] as String;
    return GestureDetector(
      onLongPress: () async {
        haptics.success();
        await tts.speak(getText(title));
      },
      onDoubleTap: () async {
        await tts.stop();
        haptics.success();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            getText(title),
            style: const TextStyle(fontSize: 17),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  // Retrieves the corresponding text based on the given `title`.
  //
  // The `title` parameter is a `String` that represents the title of the tab.
  // The function uses a switch statement to match the `title` with the corresponding
  // text. If the `title` matches one of the cases, the corresponding text is returned.
  // If the `title` does not match any of the cases, an empty string is returned.

  String getText(String title) {
    switch (title) {
      case 'SMART TEXT':
        return TStrings.textTabInfo;
      case 'QR CODE':
        return TStrings.qrCodeTabInfo;
      case 'SAFE STREET':
        return TStrings.safeStreetTabInfo;
      default:
        return '';
    }
  }
}
