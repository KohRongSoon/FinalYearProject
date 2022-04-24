import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarRecommendations extends StatefulWidget {
  List<String> recommendedCarList;
  List<String> similarityList;
  CarRecommendations(this.recommendedCarList, this.similarityList);

  @override
  State<CarRecommendations> createState() => _CarRecommendationState();
}

class _CarRecommendationState extends State<CarRecommendations> {
  List<CarDataModel> carList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    //widget.recommendedCarList.clear();
    //widget.recommendedCarList.add('Exp');
    //widget.recommendedCarList.add('X1');
    //widget.recommendedCarList.add('abc');
    if (widget.recommendedCarList.isNotEmpty) {
      print(widget.recommendedCarList);
      getData();
    } else {
      print('fail');
    }
  }

  getData() async {
    for (var item in widget.recommendedCarList) {
      await FirebaseFirestore.instance
          .collection("car")
          //.where('name', arrayContainsAny: widget.recommendedCarList)
          .where(
            'name', isEqualTo: item,
            //'abc',
            //'Exp',
            //'jsns',
            //'tsts'
          )
          .get()
          .then((value) {
        for (var item in value.docs) {
          CarDataModel carDataModel = CarDataModel.fromJson(item);
          carList.add(carDataModel);
          setState(() {});
        }
        setState(() {
          _loading = false;
        });
      });
    }
    //print('abc${carList.length}');
  }
  /*print('abc');
    print(widget.recommendedCarList);
    if (widget.recommendedCarList.isEmpty) {
      await FirebaseFirestore.instance
          .collection("car")
          //.where('name', arrayContainsAny: widget.recommendedCarList)
          .where(
            'name', isEqualTo: 'abc',
            //'abc',
            //'Exp',
            //'jsns',
            //'tsts'
          )
          .get()
          .then((value) {
        for (var item in value.docs) {
          CarDataModel carDataModel = CarDataModel.fromJson(item);
          carList.add(carDataModel);
        }
        setState(() {});
      });
    } else {
      print('fail');
      return const Center(
        child: Text("No data"),
      );
    }
    print(carList.length);
    //searchPost(searchController.text);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? circularProgress()
          : ListView.builder(
              itemCount: carList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.brown[200],
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
                    trailing: Text("${widget.similarityList[index]}%"),
                    onTap: () {
                      Navigator.of(context).pop(carList[index]);
                      carList.clear();
                      setState(() {});
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
