import 'package:carmobileapplication/models/feedback_data_model.dart';
import 'package:flutter/material.dart';

class ReviewDetailsScreen extends StatefulWidget {
  FeedbackDataModel posts;
  ReviewDetailsScreen(this.posts);

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
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
