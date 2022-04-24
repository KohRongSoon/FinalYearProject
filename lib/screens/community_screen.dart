import 'package:carmobileapplication/models/feedback_data_model.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/add_review.dart';
import 'package:carmobileapplication/screens/review_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  String name;
  CommunityScreen(this.name);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController searchController = TextEditingController();
  List<FeedbackDataModel> postList = [];
  List<FeedbackDataModel> filterPostList = [];

  @override
  void initState() {
    searchController.text = widget.name;
    getData();
    super.initState();
  }

  getData() async {
    await FirebaseFirestore.instance.collection("feedback").get().then((value) {
      for (var item in value.docs) {
        FeedbackDataModel feedbackDataModel = FeedbackDataModel.fromJson(item);
        postList.add(feedbackDataModel);
      }
      print(postList.length);
    });
    searchPost(widget.name);
    print(filterPostList.length);
    //searchPost(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            //margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              controller: searchController,
              onChanged: searchPost,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Car name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('feedback')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    postList.clear();

                    for (var item in snapshot.data.docs) {
                      FeedbackDataModel feedbackDataModel =
                          FeedbackDataModel.fromJson(item);
                      postList.add(feedbackDataModel);
                    }
                    /*StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('user').snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    postList.clear();
                    for (var item in snapshot.data.docs) {
                      FeedbackDataModel feedbackDataModel =
                          FeedbackDataModel.fromJson(item);
                      postList.add(feedbackDataModel);
                    })*/
                    return ListView.builder(
                        itemCount: filterPostList.isNotEmpty ||
                                searchController.text.isNotEmpty
                            ? filterPostList.length
                            : postList.length,
                        itemBuilder: (context, index) {
                          FeedbackDataModel posts = filterPostList.isNotEmpty ||
                                  searchController.text.isNotEmpty
                              ? filterPostList[index]
                              : postList[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewDetailsScreen(posts)));
                              },
                              child: Container(
                                //First method
                                /*
                                                      color: Colors.grey[200],
                                                      height: 300,
                                                      
                                                      margin: EdgeInsets.all(10),
                                                      child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              leading: const CircleAvatar(backgroundImage: AssetImage("images/signup.png")),
                              title: Text(feedback.title,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              subtitle: Text('${feedback.time.toDate()}', overflow: TextOverflow.ellipsis,maxLines: 2,),
                              
                              onTap: (){
                                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateCarScreen(cars)));
                              },
                                                      ),*/
                                padding:
                                    EdgeInsets.only(left: 5, top: 5, right: 5),
                                color: Colors.grey[200],
                                height: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CircleAvatar(
                                            backgroundImage:
                                                AssetImage("images/signup.png"),
                                            radius: 30),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(posts.uId,
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              '${DateFormat('yyy-MM-dd hh:mm a').format(posts.time.toDate())}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                    Container(
                                      height: 1.0,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Owner Review: ${posts.title}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                              "${posts.image![0]}",
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Image.network(
                                              "${posts.image![1]}",
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Image.network(
                                              "${posts.image![2]}",
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            posts.description,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                        )
                                      ],
                                    ),

                                    //Text("${feedback.description}"),

                                    //Text('${feedback.time.toDate()}', overflow: TextOverflow.ellipsis,maxLines: 2,),
                                    //Column()
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddReviewScreen()));
        },
      ),
    );
  }

  void searchPost(String input) {
    if (postList.isNotEmpty) {
      filterPostList.clear();
      if (input.isEmpty) {
        setState(() {});
        return;
      } else {
        for (var post in postList) {
          if (post.title.toLowerCase().contains(input.toLowerCase())) {
            filterPostList.add(post);
          }
        }
      }
      setState(() {});
    }
  }
}
