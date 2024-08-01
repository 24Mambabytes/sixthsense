import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

// haptics provider
final hapticsProvider = Provider<HapticsService>((ref) {
  return HapticsService();
});




class HapticsService {
  HapticsService();

  // check whether vibration is supported
  Future<bool> _canVibrate() {
    return Vibrate.canVibrate;
  }

  // vibrate with pauses
  void vibrateWithPauses() async {
    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
    ];
    if (await _canVibrate()) {
      Vibrate.vibrateWithPauses(pauses);
    }
  }

  // impact
  void impact() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.impact);
    }
  }

  // selection
  void selection() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }

  // success
  void success() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.success);
    }
  }

  // warning
  void warning() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.warning);
    }
  }

  // error
  void error() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.error);
    }
  }

  // heavy
  void heavy() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  // medium
  void medium() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  // light
  void light() async {
    if (await _canVibrate()) {
      Vibrate.feedback(FeedbackType.light);
    }
  }
}
