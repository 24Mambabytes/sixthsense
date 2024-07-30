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
  // The constructor for Home.
  Home({super.key});

  @override
  // Creates the state for the Home widget.
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  // The current tab index in the navigation bar
  int _currentTabIndex = 0;
  Object _currentRecognitionMode = TextRecognizer();
  late final options = FaceDetectorOptions();

  @override
  // Initializes the state of the widget.
  //
  // This method is called when the widget is first created and inserted into the tree.
  // It calls the `initState` method of the superclass and adds the current widget as an observer to the `WidgetsBinding`.
  // This allows the widget to receive notifications about changes in the application lifecycle.

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  // Disposes of the widget and removes it as an observer from the `WidgetsBinding`.
  //
  // This method is called when the widget is no longer needed and should be cleaned up.
  // It removes the widget as an observer from the `WidgetsBinding` to stop receiving notifications about changes in the application lifecycle.

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  // Called when the app's lifecycle state changes.
  //
  // This method is called by the Flutter framework to notify the widget that the app's lifecycle state has changed.
  //
  // If the new state is `AppLifecycleState.resumed`, the method reads the `textToSpeechProvider` and `hapticsProvider` from the widget's [ref] and speaks the label of the current navigation destination using the `textToSpeechProvider`. It also triggers a success haptic feedback using the `hapticsProvider`.

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final tts = ref.read(textToSpeechProvider);
      final haptics = ref.read(hapticsProvider);
      tts.speak(NavDestination.navDestinations[_currentTabIndex].label);
      haptics.success();
    }
  }

  @override
// Builds a widget that represents the home screen of the application.
//
// This method returns a `Scaffold` widget that contains an `AppBar`, a `body`, and a `bottomNavigationBar`.
// The `AppBar` displays the label of the current navigation destination, and has a elevation of 5.
// The `body` is a `MyCamera` widget that displays a camera view and recognizes objects based on the current recognition mode and current tab index.
// The `bottomNavigationBar` is a `NavigationBar` widget that displays a list of navigation destinations.

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
  //
  // This function returns a list of widgets for the app's actions, including a help button and a settings button.
  // The help button, when pressed, triggers a success haptic feedback, speaks the word "help" using text-to-speech,
  // and navigates to the "help" screen with the current tab's label as an argument.
  // The settings button, when pressed, triggers a success haptic feedback, speaks the word "settings" using text-to-speech,
  // and navigates to the "settings" screen.
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
  //
  // This function is called when a destination is selected in the app. It updates the `_currentTabIndex`
  // with the provided `value` and then calls `_toggleRecognitionMode()` to toggle the recognition mode.
  void _onDestinationSelected(int value) {
    setState(() {
      _currentTabIndex = value;
      _toggleRecognitionMode();
    });

    final textToSpeech = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
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
        _currentRecognitionMode = TextRecognizer();
      case 3:
        _currentRecognitionMode = FaceDetector(options: options);
      default:
        _currentRecognitionMode = recognitionMode;
        break;
    }
  }
}
