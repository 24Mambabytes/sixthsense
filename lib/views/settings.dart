import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/providers/haptics_provider.dart';
import 'package:sixthsense/providers/text_to_speech_provider.dart';
import 'package:sixthsense/utils/devices.dart';
import 'package:sixthsense/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/theme_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {

  late String _deviceData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: ListView(
          children: [
            _buildThemeRow(),
            const SizedBox(height: 10),
            _buildTextToSpeechControlCard(),
            const SizedBox(height: 10.0),
            _buildMoreSettingsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextToSpeechControlCard() {
    ref.watch(textToSpeechProvider);
    return Card(
      elevation: 0,
      child: Column(
        children: [
          // title
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              children: [
                const Text(
                  'Text to Speech',
                  style: TextStyle(fontSize: 17),
                ),
                const Spacer(),
                IconButton(
                    tooltip: 'press to hear',
                    onPressed: () {
                      ref.read(textToSpeechProvider.notifier).speak(
                          'This is an example of speech synthesis in english.');
                    },
                    icon: const Icon(Icons.volume_up))
              ],
            ),
          ),
          // volume slider
          Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  'Volume',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Slider(
                  onChanged: (value) {
                    ref.read(textToSpeechProvider.notifier).setVolume(value);
                  },
                  value: ref.watch(textToSpeechProvider.notifier).volume,
                  divisions: 10,
                  label: '${ref.watch(textToSpeechProvider.notifier).volume}',
                  min: 0.0,
                  max: 1.0,
                ),
              ),
            ],
          ),

          // pitch slider
          Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  'Pitch',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Slider(
                  onChanged: (value) {
                    ref.read(textToSpeechProvider.notifier).setPitch(value);
                  },
                  value: ref.watch(textToSpeechProvider.notifier).pitch,
                  divisions: 20,
                  label: '${ref.watch(textToSpeechProvider.notifier).pitch}',
                  min: 0.0,
                  max: 2.0,
                ),
              ),
            ],
          ),

          // rate slider

          Row(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  'Rate',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Slider(
                  onChanged: (value) {
                    ref.read(textToSpeechProvider.notifier).setRate(value);
                  },
                  value: ref.watch(textToSpeechProvider.notifier).rate,
                  divisions: 20,
                  label: '${ref.watch(textToSpeechProvider.notifier).rate}',
                  min: 0.0,
                  max: 2.0,
                ),
              ),
            ],
          ),

          // language
          const SizedBox(height: 10.0),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text('Language',
                    style:
                    TextStyle(fontSize: 17, color: Colors.grey.shade600)),
                const SizedBox(width: 20),
                Text(
                  ref.read(textToSpeechProvider.notifier).defaultLanguage,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25.0),
          // voice
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text('Voice',
                    style:
                    TextStyle(fontSize: 17, color: Colors.grey.shade600)),
                const SizedBox(width: 47),
                Text('${ref.read(textToSpeechProvider.notifier).voice}'),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  // theme toggle row
  Widget _buildThemeRow() {
    final theme = ref.watch(themeProvider);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 17),
            ),
            Switch(
                value: theme.isDark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDeviceInformation();
  }

  Future<void> _getDeviceInformation() async {
    final deviceData = await TDeviceFunctions.getDeviceInfoData();
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Card _buildMoreSettingsCard(BuildContext context) {
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                tts.speak('licenses');
                haptics.success();
                showLicensePage(context: context);
              },
              child: const Text(
                'Licenses',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                tts.speak('about');
                haptics.success();
                showAboutDialog(
                  applicationLegalese: TStrings.aboutInfo,
                  applicationVersion: '1.0.0',
                  context: context,
                  applicationIcon: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                        ),
                      )),
                );
              },
              child: const Text(
                'About',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () async {
                tts.speak('feedback');
                haptics.success();
                _launchFeedbackPage();
              },
              child: const Text(
                'Feedback',
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  void _launchFeedbackPage() async {
    const email = TStrings.developerEmail;
    const subject = 'Sixth Sense Feedback';
    final body = _deviceData;
    final url =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not send feedback'),
        ),
      );
    }
  }
}
