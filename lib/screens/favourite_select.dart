import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/favourite_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavouriteSelectScreen extends StatefulWidget {
  const FavouriteSelectScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteSelectScreen> createState() => _FavouriteSelectScreenState();
}

class _FavouriteSelectScreenState extends State<FavouriteSelectScreen> {
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
    getFavouriteList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? circularProgress()
          : ListView.builder(
              itemCount: favouriteList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.pink[100],
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    title: Text(
                      carList[index].name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'RM ${carList[index].price}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    onTap: () {
                      Navigator.of(context).pop(carList[index]);
                    },
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
