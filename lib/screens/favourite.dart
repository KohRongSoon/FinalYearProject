import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/favourite_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'car_details_screen.dart';

class FavouriteListScreen extends StatefulWidget {
  const FavouriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteListScreen> createState() => _FavouriteListScreenState();
}

class _FavouriteListScreenState extends State<FavouriteListScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference favourite =
      FirebaseFirestore.instance.collection('favourite');
  CollectionReference car = FirebaseFirestore.instance.collection('car');
  List<FavouriteDataModel> favouriteList = [];
  List<String> tempIDList = [];
  List<CarDataModel> carList = [];
  bool _loading = true;

  @override
  void initState() {
    //favouriteList.clear();
    getFavouriteList();
    getCarName();
    super.initState();
  }

  void getFavouriteList() async {
    await favourite.orderBy('timeAdded').get().then((value) {
      for (var item in value.docs) {
        FavouriteDataModel favourites = FavouriteDataModel.fromJson(item);
        if (favourites.userId == user!.uid) {
          setState(() {
            favouriteList.add(favourites);
            tempIDList.add(favourites.carId);
          });
        }
      }
    });
    if (tempIDList.isNotEmpty) {
      for (var item in tempIDList) {
        await car.get().then((value) {
          for (var data in value.docs) {
            CarDataModel cars = CarDataModel.fromJson(data);
            if (cars.carId == item) {
              setState(() {
                carList.add(cars);
              });
            }
          }
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void getCarName() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite List')),
      body: _loading
          ? circularProgress()
          : ListView.builder(
              itemCount: favouriteList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              CarDetailsScreen(carList[index])));
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    title: Text(
                      carList[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Time added: ${DateFormat('yyy-MM-dd hh:mm a').format(favouriteList[index].timeAdded.toDate())}',
                    ),
                    trailing: Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                    ),
                  ),
                );
              }),
    );
  }

  circularProgress() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.grey),
      ),
    );
  }
}
