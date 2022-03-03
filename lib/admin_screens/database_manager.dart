import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseManager{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future updateCar(String carId, String brand, String name,
                   int price, String year, String body, 
                   String engine, String power, String safety) 
                   async{
    try{
      await firestore.collection('car').doc(carId).update({
        'brand':brand,
        'name':name,
        'price':price,
        'year':year,
        'body':body,
        'engine':engine,
        'power':power,
        'safety':safety,
      });
    }catch(err){
      print(err);
    }

  }
  Future deleteCar(String carId) async{
    try{
        await firestore.collection('car').doc(carId).delete();
    }catch(err){
      print(err);
    }
  }

  //Get Data
  /*Future<List> read() async{
    QuerySnapshot querySnapshot;
    CarDataModel carDataModel = [] as CarDataModel;
    try{
      querySnapshot = await firestore.collection('car').get();
      if(querySnapshot.docs.isNotEmpty){
        for(var doc in querySnapshot.docs.toList()){
          carDataModel.name = doc['name'];
          carDataModel.body = doc['body'];

        }
        return carDataModel;
      }
    }catch (e){
      print(e);
    }
  }*/
}