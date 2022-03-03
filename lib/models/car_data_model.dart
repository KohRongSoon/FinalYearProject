import 'package:cloud_firestore/cloud_firestore.dart';

class CarDataModel{
  String carId;
  String name;
  String engine;
  String year;
  num price;
  String brand;
  String power;
  String body;
  String safety;



  CarDataModel({required this.carId, required this.name, required this.engine, 
  required this.year, required this.price, 
  required this.brand, required this.power, required this.body, required  this.safety});

  //retrieved data
  factory CarDataModel.fromJson(DocumentSnapshot snapshot){
    return CarDataModel(
      carId: snapshot.id,
      name: snapshot['name'],
      engine: snapshot['engine'],
      year: snapshot['year'],
      price: snapshot['price'],
      brand: snapshot['brand'],
      power: snapshot['power'],
      body: snapshot['body'],
      safety: snapshot['safety'],

    );
  }

  /*CarDataModel.fromSnapshot(snapshot)
    : carId = snapshot.data()['carId'],
      name =  snapshot.data()['name'],
      engine=  snapshot.data()['engine'],
      year =  snapshot.data()['year'],
      price =  snapshot.data()['price'],
      brand =  snapshot.data()['brand'],
      power =  snapshot.data()['power'],
      body =  snapshot.data()['body'],
      safety =  snapshot.data()['safety'];*/

  //send data
  Map<String, dynamic> toMap(){
    return{
      'carId': carId,
      'name': name,
      'engine': engine,
      'year': year,
      'price': price,
      'brand': brand,
      'power': power,
      'body': body,
      'safety': safety,
    };
  }

}