import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackDataModel {
  String feedbackId;
  String uId;
  String title;
  String description;
  Timestamp time;
  List<dynamic>? image;

  FeedbackDataModel(
      {required this.feedbackId,
      required this.uId,
      required this.title,
      required this.description,
      required this.time,
      this.image});

  //retrieved data
  factory FeedbackDataModel.fromJson(DocumentSnapshot snapshot) {
    return FeedbackDataModel(
        feedbackId: snapshot.id,
        uId: snapshot['uId'],
        title: snapshot['title'],
        description: snapshot['description'],
        time: snapshot['time'],
        image: snapshot['image']);
  }

  //send data
  Map<String, dynamic> toMap() {
    return {
      'feedbackId': feedbackId,
      'uId': uId,
      'title': title,
      'description': description,
      'time': time,
    };
  }
}
