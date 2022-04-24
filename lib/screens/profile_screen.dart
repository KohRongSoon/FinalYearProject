import 'package:carmobileapplication/screens/about_us.dart';
import 'package:carmobileapplication/screens/calculator_screen.dart';
import 'package:carmobileapplication/screens/change_profile.dart';
import 'package:carmobileapplication/screens/favourite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const IconData calculate =
      IconData(0xe121, fontFamily: 'MaterialIcons');
  static const IconData logout_rounded =
      IconData(0xf88b, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
          heightFactor: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      children: const [
                        CircleAvatar(
                          backgroundImage: AssetImage("images/carLogo.jpg"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeProfileScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text("My Account",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouriteListScreen()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.favorite),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text("Favourite",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalculatorScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(calculate),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text("Calculator",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutUsScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.people),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text("About us",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      },
                      child: Row(
                        children: [
                          Icon(logout_rounded),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text("Log Out",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
