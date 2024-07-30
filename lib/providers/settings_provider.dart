import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/utils/app_settings.dart';

final settingsProvider = ChangeNotifierProvider<AppSettingsManager>((ref) {
  return AppSettingsManager();
});
