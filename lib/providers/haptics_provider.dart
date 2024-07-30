import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/services/haptics.dart';

final hapticsProvider = Provider<HapticsService>((ref) {
  return HapticsService();
});
