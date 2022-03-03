import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/home_screen.dart';
import 'package:carmobileapplication/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ Key? key }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController repasswordController = new TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final nameInput = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value)
      {
        if (value!.isEmpty){
          return ("Please Enter Password");
        }

        if (!RegExp(r'^.{8,}$')
            .hasMatch(value)) {
          return ("Please Enter a valid name with minumum 5 characters");
            }
      },
      onSaved: (value){
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          ),
      ),
    );

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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          ),
      ),
    );

  final passwordInput = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,

      validator: (value)
      {
        if (value!.isEmpty){
          return ("Please Enter Password");
        }

        if (!RegExp(r'^.{8,}$')
            .hasMatch(value)) {
          return ("Please Enter a valid password with minumum 8 characters ");
            }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
       decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          ),
       ),
    );

  final repasswordInput = TextFormField(
        autofocus: false,
        controller: repasswordController,
        obscureText: true,
        
      validator: (value)
      {
        if (value!.isEmpty){
          return ("Please Enter Confiorm Password ");
        }
        
        if (repasswordController.text.length > 8 && passwordController.text != value){
          return "Input password does not match!";
        }

        return null;

      },
        onSaved: (value){
          repasswordController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
            ),
        ),
      );

    final registerButton = Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: Colors.redAccent,
    child: MaterialButton(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
         register(emailController.text, passwordController.text);
      },
      child: const Text(
        "Sign Up",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25, color: Colors.white
          ),
      )),
    );

    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
      )
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 120,
                      child: Image.asset("images/signup.png",
                      fit: BoxFit.contain,)
                    ),

                    SizedBox(height: 30),

                    nameInput,
                    SizedBox(height: 15),

                    emailInput,
                    SizedBox(height: 15),

                    passwordInput,
                    SizedBox(height: 15),

                    repasswordInput,
                    SizedBox(height: 20),

                    registerButton,
                    SizedBox(height: 30),
                  ]),
              ),
            ),
          )
        )
      )
    );
  }

  Future<void> register(String email, String password) async {
    if(formKey.currentState!.validate()){
      await auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => {
        passDataToFirestore()
      }).catchError((error){
        Fluttertoast.showToast(msg: error!.message);
      });
    }
  }

  passDataToFirestore() async{
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  User? user = auth.currentUser;

  UserDataModel userDataModel = UserDataModel();

  userDataModel.email = user!.email;
  userDataModel.uId = user.uid;
  userDataModel.name = nameController.text;

  await firebase
    .collection("user")
    .doc(user.uid)
    .set(userDataModel.toMap());

  Fluttertoast.showToast(msg: "Created Account successfully ");

  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),
  (route) => false);

  }
}



