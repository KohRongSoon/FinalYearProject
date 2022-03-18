import 'package:carmobileapplication/admin_screens/reuse_input.dart';
import 'package:carmobileapplication/admin_screens/view_car.dart';
import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({ Key? key }) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {

  final formKey = GlobalKey<FormState>();
  
     @override
   void initState(){
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
          title: const Text('Add Car')),
          body: Center(
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

                        SizedBox(height: 10),
                        AddPictureButton,
                        SizedBox(height: 20),
                        

                        Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue[100],
                          child: MaterialButton(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hoverColor:Colors.grey[400],
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                cars.
                                add({'brand': brandController.text, 
                                    'name': nameController.text, 
                                    'price': int.parse(priceController.text), 
                                    'year' : yearController.text, 
                                    'body' : bodyController.text,
                                    'engine' : engineController.text, 
                                    'power' : powerController.text, 
                                    'safety' :safetyController.text})
                                  .then((value) => print('Car Added'))
                                .catchError((err) => print(err));
                              }
                            },
                            child: const Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25, color: Colors.white
                                ),
                            )),
                          ),
                            ]
                        )
                    ]
                  ),
                  )  
                ),
              ),
            )
          )      
      );
    }

    void openFile(PlatformFile file) {
      OpenFile.open(file.path!);
    }

       
}



    

