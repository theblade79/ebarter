import 'dart:io';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ImageObject> _imgObjs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the HomePage object that was created by
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