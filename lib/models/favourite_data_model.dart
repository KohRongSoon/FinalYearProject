import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteDataModel {
  String favouriteId;
  String userId;
  String carId;
  Timestamp timeAdded;

  FavouriteDataModel(
      {required this.favouriteId,
      required this.userId,
      required this.carId,
      required this.timeAdded});

  //retrieved data
  factory FavouriteDataModel.fromJson(DocumentSnapshot snapshot) {
    return FavouriteDataModel(
      favouriteId: snapshot.id,
      userId: snapshot['userId'],
      carId: snapshot['carId'],
      timeAdded: snapshot['timeAdded'],
    );
  }
}
