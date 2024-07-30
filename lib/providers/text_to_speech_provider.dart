import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/services/text_to_speech.dart';

final textToSpeechProvider = Provider<TextToSpeechService>((ref) {
  return TextToSpeechService();
});
