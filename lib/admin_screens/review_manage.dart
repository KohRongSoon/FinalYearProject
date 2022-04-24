import 'package:carmobileapplication/models/feedback_data_model.dart';
import 'package:flutter/material.dart';

import 'database_manager.dart';

class ReviewManageScreen extends StatefulWidget {
  FeedbackDataModel posts;
  ReviewManageScreen(this.posts);

  @override
  State<ReviewManageScreen> createState() => _ReviewManageScreenState();
}

class _ReviewManageScreenState extends State<ReviewManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert!'),
                        content: Text(
                            'Are you confirm to delete this owner review?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          TextButton(
                              onPressed: () async {
                                await DatabaseManager()
                                    .deleteReview(widget.posts.feedbackId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Yes')),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.delete_forever_outlined, color: Colors.white))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Owner Review: ${widget.posts.title}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Post by: ${widget.posts.uId}',
                    style: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Text(widget.posts.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          )),
    );
  }
}
