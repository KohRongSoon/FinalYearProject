import 'dart:io';

import 'package:carmobileapplication/models/information_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database_manager.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  InformationDataModel information = InformationDataModel(
      informationId: '',
      image: [],
      timeAdded: Timestamp.fromDate(DateTime.now()));
  List<dynamic> imgList = [];
  List<File> _image = [];
  CollectionReference info =
      FirebaseFirestore.instance.collection('Information');
  bool _loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('Information')
        .get()
        .then((value) {
      for (var item in value.docs) {
        setState(() {
          information = InformationDataModel.fromJson(item);
        });
      }
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert!'),
                        content:
                            Text('Are you confirm to change all the picture?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          TextButton(
                              onPressed: () async {
                                await DatabaseManager().deleteInformation(
                                    information.informationId);
                                setState(() {
                                  imgList.clear();
                                  _loading = true;
                                });
                                try {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                                    allowMultiple: true,
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _image = result.paths
                                          .map((path) => File(path!))
                                          .toList();
                                    });
                                    print('abc');
                                    print(_image);
                                    print(_image.length);
                                    Navigator.pop(context);
                                  }
                                } catch (error) {
                                  Fluttertoast.showToast(
                                      msg: "Unable to procedd due to : $error");
                                }
                                uploadImages().whenComplete(() {
                                  info.add({
                                    'image': imgList,
                                    'timeAdded': DateTime.now()
                                  }).then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Information change sucessfully");
                                    setState(() {
                                      getData();
                                    });
                                    //Navigator.pop(context);
                                  }).catchError((onError) {
                                    print(onError);
                                  });
                                });
                              },
                              child: Text('Yes')),
                        ],
                      );
                    });
              },
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: _loading
            ? circularProgress()
            : GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: information.image.length,
                itemBuilder: (context, index) {
                  final file = information.image[index];

                  return Image.network(file, height: 100, fit: BoxFit.fill);
                },
              ),
      ),
    );
  }

  Future uploadImages() async {
    for (var image in _image) {
      Reference reference =
          FirebaseStorage.instance.ref().child('information/${image.path}');
      await reference.putFile(image).whenComplete(() async {
        final url = await reference.getDownloadURL();
        imgList.add(url);
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
