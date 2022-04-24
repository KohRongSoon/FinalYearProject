import 'dart:io';

import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();

  final formKey = GlobalKey<FormState>();

  //controller
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  List<File> _image = [];
  List<File> temp = [];
  List<dynamic> imgList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserDataModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference post =
        FirebaseFirestore.instance.collection('feedback');

    final titleInput = TextFormField(
      autofocus: false,
      controller: titleController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your title.");
        }
        return null;
      },
      onSaved: (value) {
        titleController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Title",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    //password part
    final descriptionInput = TextFormField(
      autofocus: false,
      controller: descriptionController,
      minLines: 1,
      maxLines: 200,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your description");
        }
        return null;
      },
      onSaved: (value) {
        descriptionController.text = value!;
      },
      decoration: InputDecoration(
        /*focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),*/
        errorMaxLines: 2,
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:
            "Description\n1. Please provide a good article structure by separating paragraphs.",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                  allowMultiple: true,
                );
                if (result != null) {
                  temp = result.paths.map((path) => File(path!)).toList();
                  if (temp.length > 2) {
                    setState(() {
                      _image = temp;
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please choose at least 3 images.');
                  }
                }
              } catch (error) {
                Fluttertoast.showToast(
                    msg: "Unable to procedd due to : $error");
              }
            },
            icon: const Icon(Icons.image),
          ),
          TextButton(
              style: TextButton.styleFrom(
                  //fixedSize: Size.fromHeight(20),
                  //backgroundColor: Colors.deepPurple,
                  primary: Colors.white,
                  padding: const EdgeInsets.all(15),
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (_image.length < 2) {
                    Fluttertoast.showToast(
                        msg: 'Please choose at least 3 images.');
                  } else {
                    setState(() {
                      _loading = true;
                    });
                    uploadImages().whenComplete(() {
                      post.add({
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'uId': currentUser.name,
                        'time': DateTime.now(),
                        'image': imgList,
                      }).then((value) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Add review sucessfully");
                      }).catchError((onError) {
                        print(onError);
                      });
                    });
                  }
                }

                return;
              },
              child: const Text('Post')),
        ],
      ),
      body: _loading
          ? circularProgress()
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleInput,
                    SizedBox(height: 10),
                    Container(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    descriptionInput,
                  ],
                ),
              ),
            ),
    );
  }

  Future uploadImages() async {
    for (var image in _image) {
      Reference reference =
          FirebaseStorage.instance.ref().child('review/${image.path}');
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
