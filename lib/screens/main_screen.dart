import 'package:carmobileapplication/screens/car_compare.dart';
import 'package:carmobileapplication/screens/car_screen.dart';
import 'package:carmobileapplication/screens/home_screen.dart';
import 'package:carmobileapplication/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  static const IconData carIcon = IconData(0xe1d7, fontFamily: 'MaterialIcons');
  static const IconData compareIcon = IconData(0xe181, fontFamily: 'MaterialIcons');

  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    SearchCarScreen(),
    CompareCarScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: Colors.blue[100],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            
          ),

          BottomNavigationBarItem(
            icon: Icon(carIcon),
            label: 'Cars',
            //backgroundColor: Colors.amber,
          ),

          BottomNavigationBarItem(
            icon: Icon(compareIcon),
            label: 'Compare',
            //backgroundColor: Colors.red,
          ),

            BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
        ],
        
      ),
    );
  }
}