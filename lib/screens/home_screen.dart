import 'package:carmobileapplication/admin_screens/add_car.dart';
import 'package:carmobileapplication/admin_screens/update_car.dart';
import 'package:carmobileapplication/admin_screens/view_car.dart';
import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/information_data_model.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/about_us.dart';
import 'package:carmobileapplication/screens/calculator_screen.dart';
import 'package:carmobileapplication/screens/car_compare.dart';
import 'package:carmobileapplication/screens/car_details_screen.dart';
import 'package:carmobileapplication/screens/car_screen.dart';
import 'package:carmobileapplication/screens/favourite.dart';
import 'package:carmobileapplication/screens/profile_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> imgList = [];
  int currentIndex = 0;
  bool _loading = true;
  List<CarDataModel> carList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('Information')
        .get()
        .then((value) {
      for (var item in value.docs) {
        setState(() {
          InformationDataModel information =
              InformationDataModel.fromJson(item);
          imgList = information.image.cast<String>();
          _loading = false;
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('car')
        .limit(2)
        .get()
        .then((value) {
      for (var item in value.docs) {
        setState(() {
          CarDataModel information = CarDataModel.fromJson(item);
          carList.add(information);
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.amber[50],
          title: Text("Home Screen"),
          elevation: 0,
        ),
        //backgroundColor: ,
        body: _loading
            ? circularProgress()
            : Padding(
                //child:SingleChildScrollView(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),

                    CarouselSlider.builder(
                      itemCount: imgList.length,
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        //pageSnapping: false,
                        viewportFraction: 1,
                        //enlargeCenterPage: true,
                        //enlargeStrategy: CenterPageEnlargeStrategy.height,
                        //enableInfiniteScroll: false,
                        onPageChanged: (index, reason) =>
                            setState(() => currentIndex = index),
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final urlImage = imgList[index];

                        return buildImage(urlImage, index);
                      },
                    ),
                    const SizedBox(height: 20),

                    //buildIndicator(),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(right: 15, left: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommunityScreen('')));
                                    //await get(Uri.parse('http://192.168.0.152:8000/'))
                                    // .then((value) => print("abc ${value.body}"));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.brown.shade300,
                                          width: 1),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.chat_outlined),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Community'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavouriteListScreen()));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.brown.shade300,
                                          width: 1),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.favorite),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Favourite'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(right: 15, left: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalculatorScreen()));
                                    //await get(Uri.parse('http://192.168.0.152:8000/')).then((value) => print("abc ${value.body}"));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.brown.shade300,
                                          width: 1),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.calculate),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Calculator'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AboutUsScreen()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.only(left: 15),
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.brown.shade300,
                                          width: 1),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.people,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('About'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Latest car:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: carList.length,
                            itemBuilder: (context, index) {
                              CarDataModel cars = carList[index];

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
                                    backgroundImage:
                                        NetworkImage(cars.image[0]),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  //leading: Icon(Icons.ac_unit),

                                  title: Text(
                                    cars.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CarDetailsScreen(cars)));
                                  },
                                ),
                              );
                            })),
                  ],
                ),
                //)
              ));
  }

  circularProgress() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.grey),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green[100],
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: imgList.length,
      effect: WormEffect(),
    );
  }
}
