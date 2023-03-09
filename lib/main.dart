import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'customImagePicker.dart';

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
      home: const MyHomePage(title: 'advance_image_picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageObject> _imgObjs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 10, 0, 5),
                  child: Text(
                    'Carica immagini',
                    style: new TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 1, 0, 10),
                    child: Text(
                      'Puoi caricare fino a 10 immagini seleziondole dalla galleria immagini o scattando direttamente una fotografia',
                      style: new TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(-0.3, -0.95),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                verticalDirection: VerticalDirection.down,
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < 10; i++)
                  if (_imgObjs.isEmpty || _imgObjs.length<=i)
                    Container(
                      width: 70,
                      height: 70,

                      decoration: BoxDecoration(
                        color: Colors.white,

                        border: Border.all(
                          color: Color(0xFF4C4B4B),
                        ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: IconButton(onPressed: () async {
                        // Get max 5 images
                        final List<ImageObject>? objects = await Navigator.of(context)
                            .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                          return  ImagePicker(maxCount: 10,initialSelectedImages: _imgObjs);
                        }));

                        if ((objects?.length ?? 0) > 0) {
                          setState(() {
                            _imgObjs = objects!;
                          });
                        }
                      }, icon: Image.asset(
                        'assets/images/camera_photo_upload_icon.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.scaleDown,
                      )),
                    )
                  else if (_imgObjs.isNotEmpty && _imgObjs.length>i)
                    FocusedMenuHolder(
                      menuWidth: MediaQuery.of(context).size.width*0.50,
                      blurSize: 5.0,
                      menuItemExtent: 45,
                      menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      duration: Duration(milliseconds: 100),
                      animateMenuItems: true,
                      blurBackgroundColor: Colors.black54,
                      bottomOffsetHeight: 100,
                      openWithTap: true,
                      menuItems: <FocusedMenuItem>[
                        //FocusedMenuItem(title: Text("Share"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
                        //FocusedMenuItem(title: Text("Favorite"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
                        FocusedMenuItem(title: Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,
                            onPressed: (){
                              setState(() {
                                  _imgObjs.removeAt(i);
                                }
                              );
                            }
                        ),
                      ],
                      onPressed: (){},
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFF4C4B4B),
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(File(_imgObjs.elementAt(i).modifiedPath),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                    ),
                ],
              ),
            ),
            /*GridView.builder(
                shrinkWrap: true,
                itemCount: _imgObjs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (BuildContext context, int index) {
                  final image = _imgObjs[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.file(File(image.modifiedPath),
                        height: 80, fit: BoxFit.cover),
                  );
                }),*/
            /*Expanded(
              child: GridView(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: _imgObjs
                    .map((e) => FocusedMenuHolder(
                  menuWidth: MediaQuery.of(context).size.width*0.50,
                  blurSize: 5.0,
                  menuItemExtent: 45,
                  menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  duration: Duration(milliseconds: 100),
                  animateMenuItems: true,
                  blurBackgroundColor: Colors.black54,
                  bottomOffsetHeight: 100,
                  openWithTap: true,
                  menuItems: <FocusedMenuItem>[
                    FocusedMenuItem(title: Text("Share"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
                    FocusedMenuItem(title: Text("Favorite"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
                    FocusedMenuItem(title: Text("Delete",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: (){
                      setState(() {
                        _imgObjs.remove(e);
                    });}),
                  ],
                  onPressed: (){},
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.asset("assets/images/image_$e.jpg"),
                        Image.file(File(e.modifiedPath),
                            height: 80, fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get max 5 images
          final List<ImageObject>? objects = await Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return  ImagePicker(maxCount: 10,initialSelectedImages: _imgObjs);
          }));

          if ((objects?.length ?? 0) > 0) {
            setState(() {
              _imgObjs = objects!;
            });
          }
        },

        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
