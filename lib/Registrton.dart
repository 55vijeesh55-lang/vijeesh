import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const BMydemo());
}

class BMydemo extends StatefulWidget {
  const BMydemo({super.key});

  @override
  State<BMydemo> createState() => MydemoState();
}

class MydemoState extends State<BMydemo> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(home: const MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {
  Future<File?> pickSelfie() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: <Widget>[
        Container(
          width: 400,
          height: 300,
          padding: new EdgeInsets.all(2.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.blueAccent,
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 300.0,
                  child: TextField(
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: 300.0,
                  child: TextField(
                    decoration: InputDecoration(hintText: "mobnum"),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: 300.0,
                  child: TextField(
                    decoration: InputDecoration(hintText: "current location"),
                  ),
                ),

                /*            const ListTile(
                                  leading: Icon(Icons.account_balance_outlined, size: 10),
                                        title: Text(
                                                            'name',
                                                           style: TextStyle(fontSize: 30.0)
                                                                              ),
                                                  subtitle: Text(
                  'mob and default location only .',
                  style: TextStyle(fontSize: 18.0)
              ),
            ),*/
                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(child: const Text('edit'), onPressed: () {}),
                    ElevatedButton(child: const Text('save'), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
