// ignore_for_file: avoid_print

import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';

final TextEditingController brandController = new TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController yearController = TextEditingController();
final TextEditingController bodyController = TextEditingController();
final TextEditingController engineController = TextEditingController();
final TextEditingController powerController = TextEditingController();
final TextEditingController safetyController = TextEditingController();

final formKey = GlobalKey<FormState>();
CollectionReference cars = FirebaseFirestore.instance.collection('car');

final brandInput = TextFormField(
  autofocus: false,
  controller: brandController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car brand");
    }
    return null;
  },
  onSaved: (value) {
    brandController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final nameInput = TextFormField(
  autofocus: false,
  controller: nameController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car name");
    }
    return null;
  },
  onSaved: (value) {
    nameController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final priceInput = TextFormField(
  autofocus: false,
  controller: priceController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car price");
    }
    if (!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) {
      return ("Please enter positive integer only.");
    }
    return null;
  },
  onSaved: (value) {
    priceController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final yearInput = TextFormField(
  autofocus: false,
  controller: yearController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car launched year");
    }
    return null;
  },
  onSaved: (value) {
    yearController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final bodyInput = TextFormField(
  autofocus: false,
  controller: bodyController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car body type");
    }
    return null;
  },
  onSaved: (value) {
    bodyController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final engineInput = TextFormField(
  autofocus: false,
  controller: engineController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car engine");
    }
    return null;
  },
  onSaved: (value) {
    engineController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final powerInput = TextFormField(
  autofocus: false,
  controller: powerController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car power");
    }
    return null;
  },
  onSaved: (value) {
    powerController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final safetyInput = TextFormField(
  autofocus: false,
  controller: safetyController,
  validator: (value) {
    if (value!.isEmpty) {
      return ("Enter car safety features");
    }
    return null;
  },
  onSaved: (value) {
    safetyController.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    errorMaxLines: 2,
    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

final AddPictureButton = Material(
  elevation: 5,
  borderRadius: BorderRadius.circular(30),
  color: Colors.blue[100],
  child: MaterialButton(
    child: Text('Pick Files'),
    onPressed: () async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
        allowMultiple: true,
      );
      if (result == null) return;
      final file = result.files.first;
      //openFile(result.files);
      print('Name:${file.name}');
    },
  ),
);

final nextButton = Material(
  elevation: 5,
  borderRadius: BorderRadius.circular(30),
  color: Colors.blue[100],
  child: MaterialButton(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      hoverColor: Colors.grey[400],
      onPressed: () {
        if (formKey.currentState!.validate()) {
          cars
              .add({
                brandController.text,
                nameController.text,
                int.parse(priceController.text),
                yearController.text,
                bodyController.text,
                engineController.text,
                powerController.text,
                safetyController.text
              })
              .then((value) => print('Car Added'))
              .catchError((err) => print(err));
        }

        /*register(brandController.text, nameController.text, 
        int.parse(priceController.text), yearController.text, 
        bodyController.text, engineController.text, 
        powerController.text, safetyController.text);*/
      },
      child: const Text(
        "Next",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, color: Colors.white),
      )),
);

void openFile(PlatformFile file) {
  OpenFile.open(file.path!);
}

    /*Future<void> register(String brand, String name, num price, String year, String body,
                          String engine, String power, String safety ) async {
      if(formKey.currentState!.validate()){
          FirebaseFirestore firebase = FirebaseFirestore.instance;
          CarDataModel carDataModel = CarDataModel();
          carDataModel.brand = brand;
          carDataModel.name = name;
          carDataModel.price = price;
          carDataModel.year = year;
          carDataModel.body = body;
          carDataModel.engine = engine;
          carDataModel.power = power;
          carDataModel.safety = safety;

          await firebase.collection("car").doc().set(carDataModel.toMap());

            /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewCarScreen()),
  (route) => false);*/

        }
                          }*/
  
     