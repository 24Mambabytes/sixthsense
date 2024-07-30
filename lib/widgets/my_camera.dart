import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:sixthsense/main.dart';
import 'package:sixthsense/providers/haptics_provider.dart';
import 'package:sixthsense/providers/text_to_speech_provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class MyCamera<T extends Object> extends ConsumerStatefulWidget
    with WidgetsBindingObserver {
  const MyCamera(
      {required this.recognizer, required this.currentTabIndex, super.key});

  final T recognizer;
  final int currentTabIndex;

  @override
  ConsumerState<MyCamera> createState() => MyCameraState();
}

class MyCameraState extends ConsumerState<MyCamera>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool isFlashEnabled = false;
  bool isLoading = false;

  late final textRecognizer = TextRecognizer();
  late final barcodeRecognizer = BarcodeScanner();
  late final faceDetector = FaceDetector(options: FaceDetectorOptions());

  // initialize resources
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraController(cameras[0]);
  }

  // dispose resources
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameras[0]);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
    );

    _cameraController = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('Camera access denied!.');
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // set flash mode
  Future<void> setFlashMode(FlashMode mode) async {
    if (_cameraController == null) {
      return;
    }

    try {
      await _cameraController!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  // toggle flash
  void toggleFlash() {
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);
    setState(() {
      if (isFlashEnabled) {
        isFlashEnabled = false;
        setFlashMode(FlashMode.off);
        tts.speak('Flash turned off');
        haptics.success();
      } else {
        isFlashEnabled = true;
        setFlashMode(FlashMode.torch);
        tts.speak('Flash turned on');
        haptics.success();
      }
    });
  }

  // show camera exception
  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  // log errors
  void _logError(String code, String? message) {
    debugPrint(
        'Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  // show the error message in a snackbar
  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // scan image
  Future<void> _scanImage() async {
    if (isLoading) return;
    final tts = ref.read(textToSpeechProvider);
    final haptics = ref.read(hapticsProvider);

    setState(() {
      isLoading = true;
    });

    if (_cameraController == null) return;

    haptics.medium();
    await tts.speak('scanning');
    await Future.delayed(const Duration(milliseconds: 1000));
    await tts.speak('hold steady');
    await Future.delayed(const Duration(milliseconds: 1000));

    if (widget.currentTabIndex == 0) {
      try {
        final inputImage = await _takePicture();
        final recognizedText = await textRecognizer.processImage(inputImage);

        await Future.delayed(const Duration(microseconds: 1000), () {
          haptics.warning();
        });

        if (recognizedText.blocks.isEmpty) {
          await tts.speak('No text recognized');
        } else {
          await tts.speak(recognizedText.text);
        }

        setState(() {
          isLoading = false;
        });
      } on CameraException catch (e) {
        setState(() {
          isLoading = false;
        });

        _showCameraException(e);
      }
    } else if (widget.currentTabIndex == 1) {
      try {
        final inputImage = await _takePicture();
        final recognizedBarcodes =
            await barcodeRecognizer.processImage(inputImage);

        Future.delayed(const Duration(microseconds: 1000), () {
          haptics.warning();
        });
        if (recognizedBarcodes.isEmpty) {
          await tts.speak('No barcode recognized');
        } else {
          await tts.speak(recognizedBarcodes.first.displayValue!);
        }

        setState(() {
          isLoading = false;
        });
      } on CameraException catch (e) {
        setState(() {
          isLoading = false;
        });

        _showCameraException(e);
      }
    } else {
      try {
        final inputImage = await _takePicture();
        List<Face> faces = await faceDetector.processImage(inputImage);

        Future.delayed(const Duration(microseconds: 1000), () {
          haptics.warning();
        });
        if (faces.isEmpty) {
          await tts.speak('No face detected');
        } else {
          await tts.speak('${faces.length} faces detected');
        }

        setState(() {
          isLoading = false;
        });
      } on CameraException catch (e) {
        setState(() {
          isLoading = false;
        });

        _showCameraException(e);
      }
    }
  }

  // take picture
  Future<InputImage> _takePicture() async {
    final pictureFile = await _cameraController!.takePicture();
    final file = File(pictureFile.path);
    final inputImage = InputImage.fromFile(file);
    return inputImage;
  }

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Scaffold();
    } else {
      return GestureDetector(
        onDoubleTap: () async {
          final tts = ref.read(textToSpeechProvider);
          final haptics = ref.read(hapticsProvider);
          haptics.success();
          await tts.stop();
        },
        onLongPress: () async {
          _scanImage();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [CameraPreview(_cameraController!), _buildBanner()],
        ),
      );
    }
  }

  // notification banner
  _buildBanner() {
    return Positioned(
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Text(
                  widget.currentTabIndex == 0
                      ? 'Long press to scan for text'
                      : widget.currentTabIndex == 1
                          ? 'Long press to scan for barcodes'
                          : 'Long press to scan for faces',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'MPLUSRounded1c'),
                ),
        ),
      ),
    );
  }
}
