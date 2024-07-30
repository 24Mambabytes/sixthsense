import 'package:text_to_speech/text_to_speech.dart';

class TextToSpeechService {
  // TODO: use this service class to configure tts engine
  final TextToSpeech _textToSpeech = TextToSpeech();
  TextToSpeechService();

  Future<void> speak(String text) async {
    await _textToSpeech.speak(text);
  }

  Future<void> stop() async {
    await _textToSpeech.stop();
  }
}
