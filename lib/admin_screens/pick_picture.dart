import 'package:carmobileapplication/admin_screens/reuse_input.dart';
import 'package:flutter/material.dart';

class PickPictureScreen extends StatefulWidget {
  const PickPictureScreen({ Key? key }) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<PickPictureScreen> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
          title: const Text('Add Car Picture')),
        backgroundColor: Colors.pink[100],
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[ 
                        AddPictureButton,
                    ]
                  ),
                  )  
                ),
              ),
            )
               
      );
  }
}