import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/screens/car_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchCarScreen extends StatefulWidget {
  const SearchCarScreen({Key? key}) : super(key: key);

  @override
  State<SearchCarScreen> createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
  final TextEditingController searchController = TextEditingController();
  List<CarDataModel> carList = [];
  List<CarDataModel> filterCarList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: const Text('Car Page')),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
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

                            print(index);
                            print(cars.brand);
                            print(cars.name);

                            //print(carList[index].carId);
                            //print(carList.length);
                            return Card(
                              //color: Colors.green[200],

                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(cars.image[0]),
                                  backgroundColor: Colors.transparent,
                                ),
                                //leading: Icon(Icons.ac_unit),

                                title: Text(
                                  cars.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'RM ${cars.price}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CarDetailsScreen(cars)));
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
        )
        /*body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('car')
            .orderBy('brand', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    CarDataModel cars =
                        CarDataModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      //color: Colors.green[200],
                      elevation: 5,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/images.jpg?alt=media&token=c1633e2e-f0a1-4d5d-8547-55e324291110'),
                          backgroundColor: Colors.transparent,
                        ),
                        //leading: Icon(Icons.ac_unit),

                        title: Text(
                          cars.brand,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          cars.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: () {
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateCarScreen(cars)));
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
      ),*/
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
