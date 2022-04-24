import 'package:carmobileapplication/admin_screens/add_car.dart';
import 'package:carmobileapplication/admin_screens/change_profile.dart';
import 'package:carmobileapplication/admin_screens/community_screen.dart';
import 'package:carmobileapplication/admin_screens/database_manager.dart';
import 'package:carmobileapplication/admin_screens/update_car.dart';
import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'information.dart';

class ViewCarScreen extends StatefulWidget {
  const ViewCarScreen({Key? key}) : super(key: key);

  @override
  _ViewCarScreenState createState() => _ViewCarScreenState();
}

class _ViewCarScreenState extends State<ViewCarScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();
  final TextEditingController searchController = new TextEditingController();
  List<CarDataModel> carList = [];
  List<CarDataModel> filterCarList = [];
  static const IconData logout_rounded =
      IconData(0xf88b, fontFamily: 'MaterialIcons');
  static const IconData info = IconData(0xe33c, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserDataModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextField(
              controller: searchController,
              onChanged: searchCar,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Car Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('car')
                  .orderBy('name', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    carList.clear();
                    for (var item in snapshot.data.docs) {
                      CarDataModel carDataModel = CarDataModel.fromJson(item);
                      carList.add(carDataModel);
                    }
                    return ListView.builder(
                        itemCount: filterCarList.isNotEmpty ||
                                searchController.text.isNotEmpty
                            ? filterCarList.length
                            : carList.length,
                        itemBuilder: (context, index) {
                          CarDataModel cars = filterCarList.isNotEmpty ||
                                  searchController.text.isNotEmpty
                              ? filterCarList[index]
                              : carList[index];

                          //print(carList[index].carId);
                          print(filterCarList.length);
                          print(carList.length);
                          return Card(
                            //color: Colors.green[200],

                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(cars.image[0]),
                                backgroundColor: Colors.transparent,
                              ),
                              //leading: Icon(Icons.ac_unit),

                              title: Text(
                                cars.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'RM ${cars.price}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateCarScreen(cars)));
                              },
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Text("No data"),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddCarScreen()));
        },
      ),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.blueGrey[300],
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/profile.jpg?alt=media&token=12f35a95-8520-4865-b08e-0abea2759efe',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text('${currentUser.name}', style: TextStyle(fontSize: 25)),
              ],
            )),
          ),
          /*ListTile(
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeAProfileScreen()));
            },
          ),*/
          ListTile(
            leading: Icon(info),
            title: const Text('Information'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InformationScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_outlined),
            title: const Text('Community'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommunityManageScreen()));
            },
          ),
          ListTile(
            leading: Icon(logout_rounded),
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
          ),
        ],
      )),
    );
  }

  void searchCar(String input) {
    filterCarList.clear();
    if (input.isEmpty) {
      setState(() {});
      return;
    } else {
      for (var car in carList) {
        if (car.name.toLowerCase().contains(input.toLowerCase())) {
          filterCarList.add(car);
        }
      }
    }
    setState(() {});
  }
}
