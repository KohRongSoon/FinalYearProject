import 'dart:math';

import 'package:carmobileapplication/admin_screens/view_car.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/car_details_screen.dart';
import 'package:carmobileapplication/screens/home_screen.dart';
import 'package:carmobileapplication/screens/main_screen.dart';
import 'package:carmobileapplication/screens/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'car_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();
  

  //controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();

  @override
  Widget build(BuildContext context) {

    // email part
    final emailInput = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value)
      {
        if (value!.isEmpty){
          return ("Enter your Email Address.");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
              }

        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          ),
      ),
    );

    //password part
    final passwordInput = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordController,
      
      validator: (value)
      {
        if (value!.isEmpty){
          return ("Please Enter Password");
        }

        if (!RegExp(r'^.{8,}$')
            .hasMatch(value)) {
          return ("Please Enter a valid password with minumum 8 characters");
            }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
       decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        //errorText: min(a, b),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          ),
       ),
    );

  final loginButton = Material(
  
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: Colors.redAccent,
    child: MaterialButton(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        Login(emailController.text, passwordController.text);
      },
      child: const Text(
        "Login",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25, color: Colors.white
          ),
      )),
    );
  

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 200,
                      child: Image.asset("images/carLogo.jpg",
                      fit: BoxFit.contain,)
                    ),

                    SizedBox(height: 40),
                    emailInput,
                    SizedBox(height: 25),

                    passwordInput,
                    SizedBox(height: 30),

                    loginButton,
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Do not have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => 
                                  RegisterScreen()));
                                  
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)
                            ),
                          ),    
                      ],
                    )
                  ]),
              ),
            ),
          )
        )
      )
    );
  }


  void Login(String email, String password) async {
      if (formKey.currentState!.validate()) {
       
          await auth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((uid) => {
                checkAdminUser()
                  /*Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ViewCarScreen())),*/
                /*if(checkAdminUser(uid)){                    

                  }
                else{
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen())),
                }   */    
                  }).catchError((err)
                  {
                    Fluttertoast.showToast(msg: err!.message);
                  });
        
        
      }
    }
  
  checkAdminUser() async{
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  User? user = auth.currentUser;

  UserDataModel userDataModel = UserDataModel();

  await firebase
      .collection("user")
      .doc(user?.uid)
      .get()
      .then((value){
        this.currentUser = UserDataModel.fromMap(value.data());
      });

  if('${currentUser.isAdmin}' == 'true'){
    Fluttertoast.showToast(msg: "Login Successful Admin");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ViewCarScreen()));
  } else{
    Fluttertoast.showToast(msg: "Login Successful User");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()));
       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
  }
  }
}