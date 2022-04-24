import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeAProfileScreen extends StatefulWidget {
  const ChangeAProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChangeAProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeAProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController repasswordController =
      new TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();

  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserDataModel.fromMap(value.data());
      setState(() {
        nameController.text = currentUser.name!;
        emailController.text = currentUser.email!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameInput = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }

        if (!RegExp(r'^.{5,}$').hasMatch(value)) {
          return ("Please Enter a valid name with minumum 5 characters");
        }
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        prefixIcon: Icon(Icons.people),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final emailInput = TextFormField(
      //initialValue: currentUser.email,
      enabled: false,
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter your Email Address.");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }

        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        prefixIcon: Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordInput = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _hidePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }

        if (!RegExp(r'^.{8,}$').hasMatch(value)) {
          return ("Please Enter a valid password with minumum 8 characters ");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          )),
    );

    final repasswordInput = TextFormField(
      autofocus: false,
      controller: repasswordController,
      obscureText: _hidePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Confirm Password ");
        }

        if (passwordController.text != value) {
          return "Input password does not match!";
        }

        return null;
      },
      onSaved: (value) {
        repasswordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          )),
    );

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            changePassword(passwordController.text, nameController.text);
          },
          child: const Text(
            "Update Information",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.white),
          )),
    );

    return Scaffold(
        //backgroundColor: Colors.lightGreen[100],
        appBar: AppBar(
          title: const Text('Profile Details'),
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
                        child: Image.asset(
                          "images/signup.png",
                          fit: BoxFit.contain,
                        )),
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
        ))));
  }

  Future<void> changePassword(String password, String name) async {
    if (formKey.currentState!.validate()) {
      user!.updatePassword(password).then((_) async {
        try {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user!.uid)
              .update({
            'name': name,
          });
        } catch (err) {
          Fluttertoast.showToast(msg: '$err');
        }
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Change account details sucessfully');
      }).catchError((err) {
        Fluttertoast.showToast(msg: err!.message);
      });
    }
  }
}
