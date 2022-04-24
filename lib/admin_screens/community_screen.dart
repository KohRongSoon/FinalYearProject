import 'package:carmobileapplication/admin_screens/review_manage.dart';
import 'package:carmobileapplication/models/feedback_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityManageScreen extends StatefulWidget {
  const CommunityManageScreen({Key? key}) : super(key: key);

  @override
  State<CommunityManageScreen> createState() => _CommunityManageScreenState();
}

class _CommunityManageScreenState extends State<CommunityManageScreen> {
  final TextEditingController searchController = TextEditingController();
  List<FeedbackDataModel> postList = [];
  List<FeedbackDataModel> filterPostList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Reviews'),
        backgroundColor: Colors.blue[900],
      ),
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
                  hintText: 'Somethings...',
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
                                        ReviewManageScreen(posts)));
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
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddReviewScreen()));
        },
      ),*/
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
