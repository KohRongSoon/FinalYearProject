import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/favourite_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarDetailsScreen extends StatefulWidget {
  CarDataModel cars;
  CarDetailsScreen(this.cars);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  List<String> imgList = [];
  int currentIndex = 0;
  bool isFavourite = false;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference favourite =
      FirebaseFirestore.instance.collection('favourite');
  Icon icon = const Icon(
    Icons.favorite_outline,
    color: Colors.red,
  );
  FavouriteDataModel currentFavourite = FavouriteDataModel(
      carId: '',
      favouriteId: '',
      timeAdded: Timestamp.fromDate(DateTime.now()),
      userId: '');

  @override
  void initState() {
    super.initState();
    if (widget.cars.image.isNotEmpty) {
      imgList = widget.cars.image.cast<String>();
    } else {
      print('error');
    }
    checkIsFavourite();
  }

  void checkIsFavourite() async {
    await favourite.get().then((value) {
      for (var item in value.docs) {
        FavouriteDataModel favourite = FavouriteDataModel.fromJson(item);
        if (favourite.userId == user!.uid &&
            favourite.carId == widget.cars.carId) {
          setState(() {
            icon = Icon(Icons.favorite_outlined, color: Colors.red);
            isFavourite = true;
            currentFavourite = favourite;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: imgList.length,
                options: CarouselOptions(
                  height: 200,
                  //autoPlay: true,
                  //autoPlayInterval: Duration(seconds: 5),
                  //pageSnapping: false,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
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
              buildIndicator(),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(children: [
                        Text('Car Brand:  '),
                        Text(widget.cars.brand,
                            style: TextStyle(
                                height: 1.5,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        Text('Car Name:  '),
                        Text(widget.cars.name,
                            style: TextStyle(
                                height: 1.5,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold))
                      ]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Price:  '),
                          Text('RM ${widget.cars.price}',
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Year:  '),
                          Text(widget.cars.year,
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Safety:  '),
                          Text(widget.cars.safety,
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Horsepower:  '),
                          Text(widget.cars.power,
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Engine:  '),
                          Text(widget.cars.engine,
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Car Body Type:  '),
                          Text(widget.cars.body,
                              style: TextStyle(
                                  height: 1.5,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: icon,
        onPressed: () async {
          checkIsFavourite();
          if (isFavourite) {
            try {
              await favourite.doc(currentFavourite.favouriteId).delete();
              setState(() {
                icon = Icon(
                  Icons.favorite_outline,
                  color: Colors.red,
                );
                isFavourite = false;
                Fluttertoast.showToast(msg: 'Car remove from favourite list');
              });
            } catch (err) {
              print(err);
            }
          } else {
            await favourite.add({
              'carId': widget.cars.carId,
              'userId': user!.uid,
              'timeAdded': DateTime.now()
            });
            setState(() {
              icon = Icon(
                Icons.favorite_outlined,
                color: Colors.red,
              );
            });
            Fluttertoast.showToast(msg: 'Car add to favourite list');
          }
        },
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
    );
  }
}
