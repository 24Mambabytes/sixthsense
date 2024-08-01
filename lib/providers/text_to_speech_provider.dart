// ignore_for_file: unused_field, prefer_final_fields
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_to_speech/text_to_speech.dart';

// tts provider
final textToSpeechProvider =
ChangeNotifierProvider<TextToSpeechNotifier>((ref) {
  return TextToSpeechNotifier();
});

class TextToSpeechNotifier extends ChangeNotifier {
  TextToSpeech _tts = TextToSpeech();

  TextToSpeechNotifier() {
    _loadPrefs();
  }

  final String defaultLanguage = 'en-US';
  double volume = 0.0; // Range: 0-1
  double rate = 0.0; // Range: 0-2
  double pitch = 0.0; // Range: 0-2

  String? voice;

  // shared prefs keys
  static const String _volumeKey = 'volume';
  static const String _rateKey = 'rate';
  static const String _pitchKey = 'pitch';

  // load prefs
  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    volume = prefs.getDouble(_volumeKey) ?? 1.0;
    rate = prefs.getDouble(_rateKey) ?? 1.0;
    pitch = prefs.getDouble(_pitchKey) ?? 1.0;
    voice = await getVoiceByLang(defaultLanguage);
    notifyListeners();
  }

  // save prefs
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, volume);
    await prefs.setDouble(_rateKey, rate);
    await prefs.setDouble(_pitchKey, pitch);
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await _tts.getVoiceByLang(defaultLanguage);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  // set volume
  Future<void> setVolume(double newVolume) async{
    volume = newVolume;
    _saveSettings();
    notifyListeners();
  }

  // set rate
  Future<void> setRate(double newRate) async{
    rate = newRate;
    _saveSettings();
    notifyListeners();
  }

  // set pitch
  Future<void> setPitch(double newPitch) async{
    pitch = newPitch;
    _saveSettings();
    notifyListeners();
  }

  // stop speaking
  Future<void> stop() async {
    await _tts.stop();
  }

  // reset prefs
  Future<void> resetPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_volumeKey);
    await prefs.remove(_rateKey);
    await prefs.remove(_pitchKey);
    notifyListeners();
  }

  // speak
  Future<void> speak(String text) async{
    await _tts.setVolume(volume);
    await _tts.setRate(rate);
    await _tts.setPitch(pitch);
    await _tts.setLanguage(defaultLanguage);
    await _tts.speak(text);
    await _saveSettings();
  }
}
