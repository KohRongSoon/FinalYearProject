import 'dart:convert';

import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/screens/car_recommendation.dart';
import 'package:carmobileapplication/screens/car_selected.dart';
import 'package:carmobileapplication/screens/favourite_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CarControllerScreen extends StatefulWidget {
  String name;
  CarControllerScreen(this.name);

  @override
  State<CarControllerScreen> createState() => _CarControllerState();
}

class _CarControllerState extends State<CarControllerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<String> recommendCarList = [];
  List<String> similarityList = [];

  @override
  void initState() {
    super.initState();
    recommendCarList.clear();
    if (widget.name != '') {
      getSimilarity(widget.name);
    }

    _controller = TabController(length: 3, vsync: this);
  }

  Future<void> getSimilarity(String name) async {
    String url = "http://192.168.0.152:8000/$name";

    Response response = await get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      print(response.body);
      var temp = json.decode(response.body);
      for (var item in temp) {
        var x = item;
        List<String> data = x.split(",");
        print(data);

        recommendCarList.add(data[0]);
        similarityList.add(data[1]);
      }
      print(recommendCarList);
    } else {
      throw Exception('Failed to add role');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(''),
          ),
          title: const Text('Car Selection Page'),
          centerTitle: true,
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(text: 'Car List'),
              Tab(text: 'Recommend'),
              Tab(text: 'Favourite')
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            const CarSelectScreen(),
            CarRecommendations(recommendCarList, similarityList),
            const FavouriteSelectScreen()
          ],
        ),
      ),
    );
  }
}
