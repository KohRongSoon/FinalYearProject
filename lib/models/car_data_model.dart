import 'package:cloud_firestore/cloud_firestore.dart';

class CarDataModel {
  String carId;
  String name;
  String engine;
  String year;
  num price;
  String brand;
  String power;
  String body;
  String safety;
  List<dynamic> image;

  CarDataModel(
      {required this.carId,
      required this.name,
      required this.engine,
      required this.year,
      required this.price,
      required this.brand,
      required this.power,
      required this.body,
      required this.safety,
      required this.image});

  //retrieved data
  factory CarDataModel.fromJson(DocumentSnapshot snapshot) {
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
        image: snapshot['image']);
  }
  /*factory CarDataModel.fromMap(map) {
    return CarDataModel(
        carId: map.id,
        name: map['name'],
        engine: map['engine'],
        year: map['year'],
        price: map['price'],
        brand: map['brand'],
        power: map['power'],
        body: map['body'],
        safety: map['safety'],
        image: map['image']);
  }*/

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
  Map<String, dynamic> toMap() {
    return {
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
  /*factory CarDataModel.fromMap(map){
    return CarDataModel(
      carId: map['carId'],
      name: map['name'],
      engine: map['engine'],
      year: map['year'],
      price: map['price'],
      brand: map['brand'],
      power: map['power'],
      body: map['body'],
      safety: map['safety'],

    );
  }*/

}
