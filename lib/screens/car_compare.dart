import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({ Key? key }) : super(key: key);

  @override
  State<CompareCarScreen> createState() => _CompareCarScreenState();
}

class _CompareCarScreenState extends State<CompareCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Details Page')),
        body: Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.lightGreen[100],
                child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  //minWidth: MediaQuery.of(context).size.width,
                  minWidth: 200.0,
                  onPressed: () {
                    //Login(emailController.text, passwordController.text);
                  },
                  child: const Text(
                    "Add Car",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25, color: Colors.black
                      ),
                    )
                  ),
              ),
            ),
          ),
          
          
        ),
     
    );
  }
}