import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ui/home.dart';


// We don't care about missing API docs in the example app.
// ignore_for_file: public_member_api_docs

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  runApp(const MyApp());
}

/// Example app.
class MyApp extends StatelessWidget {
  /// Example app constructor.
  const MyApp({final Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Setup image picker configs
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.green;
    configs.albumGridCount=4;
    configs.appBarDoneButtonColor=Colors.white;
    configs.doneButtonStyle=DoneButtonStyle.iconButton;
    //configs.doneButtonIcon=Icons.add_circle_outline;
    //configs.
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };
    configs.albumPickerModeEnabled=true;
    configs.cameraPickerModeEnabled=true;
    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const HomePage(title: 'advance_image_picker Demo'),
    );
  }
}
