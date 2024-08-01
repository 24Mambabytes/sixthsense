import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:sixthsense/models/nav_destination.dart';
import 'package:sixthsense/providers/haptics_provider.dart';
import 'package:sixthsense/providers/text_to_speech_provider.dart';
import 'package:sixthsense/widgets/my_camera.dart';

// `Home` is the main screen of the application.
class Home extends ConsumerStatefulWidget {
  final myCameraKey = GlobalKey<MyCameraState>();
  Home({super.key});

  @override
  // Creates the state for the Home widget.
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  // The current tab index in the navigation bar
  int _currentTabIndex = 0;
  Object _currentRecognitionMode = TextRecognizer();


  // Initializes the state of the widget.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Disposes of the widget and removes it as an observer from the `WidgetsBinding`.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when the app's lifecycle state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final tts = ref.read(textToSpeechProvider);
      final haptics = ref.read(hapticsProvider);
      tts.speak(NavDestination.navDestinations[_currentTabIndex].buttonInfo);
      haptics.success();
    }
  }

  // Builds a widget that represents the home screen of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(NavDestination.navDestinations[_currentTabIndex].label),
        centerTitle: true,
        actions: _buildActions(context: context),
        // flash button
        leading: IconButton(
          tooltip: 'flashlight',
          icon: (widget.myCameraKey.currentState == null)
              ? const Icon(Icons.flash_on)
              : Icon(widget.myCameraKey.currentState!.isFlashEnabled
                  ? Icons.flash_on
                  : Icons.flash_off),
          onPressed: () async {
            widget.myCameraKey.currentState!.toggleFlash();
            setState(() {});
          },
        ),
      ),
      body: MyCamera(
          key: widget.myCameraKey,
          recognizer: _currentRecognitionMode,
          currentTabIndex: _currentTabIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: NavDestination.navDestinations
            .map((item) => NavigationDestination(
                icon: item.icon, label: item.label, tooltip: item.buttonInfo))
            .toList(),
      ),
    );
  }

  // Builds a list of widgets for the app's actions.
  List<Widget> _buildActions({required BuildContext context}) {
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    return [
      // help button
      IconButton(
        onPressed: () {
          haptics.success();
          tts.speak('help');
          Navigator.pushNamed(context, 'help', arguments: {
            'title': NavDestination.navDestinations[_currentTabIndex].label
          });
        },
        tooltip: 'help',
        icon: const Icon(Icons.help_center),
      ),

      // settings button
      IconButton(
        onPressed: () {
          haptics.success();
          tts.speak('settings');
          Navigator.pushNamed(context, 'settings');
        },
        icon: const Icon(Icons.settings),
        tooltip: 'settings',
      )
    ];
  }

  // Updates the current tab index and toggles the recognition mode based on the selected value.
  void _onDestinationSelected(int value) {
    final textToSpeech = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    setState(() {
      _currentTabIndex = value;
      _toggleRecognitionMode();
    });
    textToSpeech
        .speak(NavDestination.navDestinations[_currentTabIndex].buttonInfo);
    haptics.success();
  }

  // Toggles the recognition mode based on the current tab index.
  void _toggleRecognitionMode() {
    Object recognitionMode = '';
    switch (_currentTabIndex) {
      case 0:
        _currentRecognitionMode = TextRecognizer();
      case 1:
        _currentRecognitionMode = BarcodeScanner();
      case 2:
        _currentRecognitionMode = FaceDetector(options: FaceDetectorOptions());
      default:
        _currentRecognitionMode = recognitionMode;
        break;
    }
  }
}
