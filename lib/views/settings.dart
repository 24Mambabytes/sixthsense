import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/providers/haptics_provider.dart';
import 'package:sixthsense/providers/settings_provider.dart';
import 'package:sixthsense/providers/text_to_speech_provider.dart';
import 'package:sixthsense/utils/devices.dart';
import 'package:sixthsense/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

//FIXME: implement tts engine and haptics settings
// TODO: add auditory and haptic feedback for settings controls
class _SettingsState extends ConsumerState<Settings> {
  late String _deviceData;
  double volume = 0.5;
  double pitch = 0.5;
  double rate = 0.5;
  bool isHapticsOn = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildThemeCard(),
            _buildTextToSpeechControlsCard(),
            _buildHapticsCard(),
            _buildMoreSettingsCard(context),
          ],
        ),
      ),
    );
  }

  // theme switcher card
  Card _buildThemeCard() {
    final themeMode = ref.watch(settingsProvider);
    return Card(
        elevation: 0,
        child: SwitchListTile(
          value: themeMode.currentTheme == ThemeMode.dark ? true : false,
          onChanged: (value) {
            themeMode.toggleTheme();
          },
          enableFeedback: true,
          title: const Text('Theme'),
        ));
  }

  // text to speech controls card
  Card _buildTextToSpeechControlsCard() {
    final List<String> dummyLanguages = [
      'English',
      'Spanish',
    ];
    final List<String> dummyVoices = [
      'Alex',
    ];
    final volumeRow = Row(
      children: [
        const Text('Volume'),
        Expanded(
            child: Slider(
                value: volume,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                })),
        Text('(${volume.toStringAsFixed(1)})'),
      ],
    );
    final pitchRow = Row(
      children: [
        const Text('Pitch'),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Slider(
                value: pitch,
                onChanged: (value) {
                  setState(() {
                    pitch = value;
                  });
                })),
        Text('(${pitch.toStringAsFixed(1)})')
      ],
    );
    final rateRow = Row(
      children: [
        const Text('Rate'),
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: Slider(
                value: rate,
                onChanged: (value) {
                  setState(() {
                    rate = value;
                  });
                })),
        Text('(${rate.toStringAsFixed(1)})')
      ],
    );
    final languageRow = Row(
      children: [
        const Text('Language'),
        const SizedBox(width: 50),
        DropdownButton<String>(
          value: 'English',
          onChanged: (value) {},
          items: dummyLanguages
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
        )
      ],
    );

    final voiceRow = Row(
      children: [
        const Text('Voice'),
        const SizedBox(width: 73),
        DropdownButton<String>(
          value: 'Alex',
          onChanged: (value) {},
          items: dummyVoices
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
        )
      ],
    );
    final titleRow = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Text to speech',
            style: TextStyle(fontSize: 20),
          ),
          IconButton(
              onPressed: () {
                final tts = ref.read(textToSpeechProvider);
                tts.speak('hello world');
              },
              tooltip: 'play to hear sound',
              icon: const Icon(Icons.volume_up))
        ],
      ),
    );

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 17.0),
        child: Column(
          children: [
            titleRow,
            // volume row
            volumeRow,
            // pitch row
            pitchRow,
            // rate row
            rateRow,
            // language row
            languageRow,
            // voice row
            voiceRow,
          ],
        ),
      ),
    );
  }

  // build haptic feedback card
  Card _buildHapticsCard() {
    return Card(
        elevation: 0,
        child: SwitchListTile(
          value: isHapticsOn,
          onChanged: (value) {
            setState(() {
              isHapticsOn = value;
            });
          },
          enableFeedback: true,
          title: const Text('Haptics'),
        ));
  }

  // more setting card
  Card _buildMoreSettingsCard(BuildContext context) {
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            //const Text('OTHERS', style: TextStyle(fontSize: 20),),
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
