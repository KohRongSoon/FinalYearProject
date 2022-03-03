import 'package:carmobileapplication/admin_screens/add_car.dart';
import 'package:carmobileapplication/admin_screens/update_car.dart';
import 'package:carmobileapplication/admin_screens/view_car.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/car_compare.dart';
import 'package:carmobileapplication/screens/car_details_screen.dart';
import 'package:carmobileapplication/screens/car_screen.dart';
import 'package:carmobileapplication/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();

  static const IconData carIcon = IconData(0xe1d7, fontFamily: 'MaterialIcons');
  static const IconData compareIcon = IconData(0xe181, fontFamily: 'MaterialIcons');

  int _selectedIndex = 0;

  final screens = [
    HomeScreen(),
    SearchCarScreen(),
    CompareCarScreen(),
    ProfileScreen()
  ];
    

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>screens[_selectedIndex]));
    });
  }

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
      .collection("user")
      .doc(user!.uid)
      .get()
      .then((value){
        this.currentUser = UserDataModel.fromMap(value.data());
        setState((){});
      });

  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              SizedBox(height: 40),
              Text(
                "${currentUser.name} ${currentUser.email}",
                style: TextStyle(fontSize: 25),
                ),
              SizedBox(height: 40),
                                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Test"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => 
                                  CarDetailsScreen()));
                                  
                          },
                          child: Text(
                            "Test",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)
                            ),
                          ),    
                      ],
                    )
            ],
              )
            )
          ),
        
        
        bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: Colors.blue[100],
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(carIcon),
            
            label: 'Cars',
          ),

          BottomNavigationBarItem(
            icon: Icon(compareIcon),
            label: 'Compare',
          ),

            BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
          /*BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/carIcon.jpg"),
                color: Color(0xFF3A5A98),
               ),
           label: 'Profile',
          ),*/
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      );
  }
}

