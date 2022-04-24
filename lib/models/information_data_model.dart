import 'package:cloud_firestore/cloud_firestore.dart';

class InformationDataModel {
  String informationId;
  List<dynamic> image;
  Timestamp timeAdded;

  InformationDataModel(
      {required this.informationId,
      required this.image,
      required this.timeAdded});

  //retrieved data
  factory InformationDataModel.fromJson(DocumentSnapshot snapshot) {
    return InformationDataModel(
      informationId: snapshot.id,
      image: snapshot['image'],
      timeAdded: snapshot['timeAdded'],
    );
  }
}
