import 'dart:io';

import 'package:carmobileapplication/admin_screens/pick_picture.dart';
import 'package:carmobileapplication/admin_screens/reuse_input.dart';
import 'package:carmobileapplication/admin_screens/view_car.dart';
import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

import 'package:firebase_storage/firebase_storage.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final formKey = GlobalKey<FormState>();
  List<File> _image = [];
  List<String> imgUrl = [];

  bool _loading = false;

  @override
  void initState() {
    brandController.text = '';
    nameController.text = '';
    priceController.text = '';
    yearController.text = '';
    bodyController.text = '';
    engineController.text = '';
    powerController.text = '';
    safetyController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference cars = FirebaseFirestore.instance.collection('car');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Car'),
          backgroundColor: Colors.blue[900],
        ),
        body: _loading
            ? circularProgress()
            : Center(
                child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Car Brand'),
                              brandInput,
                              SizedBox(height: 10),
                              Text('Car Name'),
                              nameInput,
                              SizedBox(height: 10),
                              Text('Car Price'),
                              priceInput,
                              SizedBox(height: 10),
                              Text('Car Launched Year'),
                              yearInput,
                              SizedBox(height: 10),
                              Text('Car Body Type'),
                              bodyInput,
                              SizedBox(height: 10),
                              Text('Car Engine'),
                              engineInput,
                              SizedBox(height: 10),
                              Text('Car Power'),
                              powerInput,
                              SizedBox(height: 10),
                              Text('Car Safety Features'),
                              safetyInput,
                              SizedBox(height: 30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5,
                                      color: Colors.brown[300],
                                      child: MaterialButton(
                                          minWidth: 350,
                                          padding: EdgeInsets.fromLTRB(
                                              20, 15, 20, 15),
                                          hoverColor: Colors.grey[400],
                                          onPressed: () async {
                                            try {
                                              final result = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'png',
                                                  'jpeg'
                                                ],
                                                allowMultiple: true,
                                              );
                                              if (result != null) {
                                                setState(() {
                                                  _image = result.paths
                                                      .map(
                                                          (path) => File(path!))
                                                      .toList();
                                                });
                                                print('abc');
                                                print(_image);
                                                print(_image.length);
                                                openFiles(result.files);
                                              }
                                            } catch (error) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Unable to procedd due to : $error");
                                            }
                                          },
                                          child: const Text(
                                            "Pick Picture",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          )),
                                    ),
                                  ]),
                              SizedBox(height: 30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5,
                                      //borderRadius: BorderRadius.circular(30),
                                      color: Colors.blue[400],
                                      child: MaterialButton(
                                          minWidth: 350,
                                          padding: EdgeInsets.fromLTRB(
                                              20, 15, 20, 15),
                                          hoverColor: Colors.grey[400],
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _loading = true;
                                              });
                                              uploadImages(nameController.text)
                                                  .whenComplete(() {
                                                cars.add({
                                                  'brand': brandController.text,
                                                  'name': nameController.text,
                                                  'price': int.parse(
                                                      priceController.text),
                                                  'year': yearController.text,
                                                  'body': bodyController.text,
                                                  'engine':
                                                      engineController.text,
                                                  'power': powerController.text,
                                                  'safety':
                                                      safetyController.text,
                                                  'image': imgUrl
                                                }).then((value) {
                                                  setState(() {
                                                    _loading = false;
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Car added sucessfully");
                                                  Navigator.pop(context);
                                                }).catchError((err) {
                                                  setState(() {
                                                    _loading = false;
                                                  });
                                                  print(err);
                                                });
                                              });
                                            }
                                          },
                                          child: const Text(
                                            "Save",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          )),
                                    ),
                                  ])
                            ]),
                      )),
                ),
              )));
  }

  void openFiles(List<PlatformFile> file) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PickPictureScreen(
              files: file,
              onOpenedFile: openFile,
            )));
  }

  Future uploadImages(String text) async {
    for (var image in _image) {
      Reference reference =
          FirebaseStorage.instance.ref().child('car/$text/${image.path}');
      await reference.putFile(image).whenComplete(() async {
        final url = await reference.getDownloadURL();
        imgUrl.add(url);
      });
    }
  }

  circularProgress() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.grey),
      ),
    );
  }
}
