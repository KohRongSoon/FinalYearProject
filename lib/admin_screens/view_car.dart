import 'package:carmobileapplication/admin_screens/add_car.dart';
import 'package:carmobileapplication/admin_screens/database_manager.dart';
import 'package:carmobileapplication/admin_screens/update_car.dart';
import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:carmobileapplication/models/user_data_model.dart';
import 'package:carmobileapplication/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ViewCarScreen extends StatefulWidget {
  const ViewCarScreen({ Key? key }) : super(key: key);

  @override
  _ViewCarScreenState createState() => _ViewCarScreenState();
}

class _ViewCarScreenState extends State<ViewCarScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserDataModel currentUser = UserDataModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
      .collection("user")
      .doc(user!.uid)
      .get()
      .then((value){
        currentUser = UserDataModel.fromMap(value.data());
        setState((){});
      });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: const Text('Home ')),
       body: StreamBuilder(
         stream: FirebaseFirestore.instance.collection('car').orderBy('brand',descending: false).snapshots(),
         builder: (context, AsyncSnapshot snapshot){
           if (snapshot.hasData){
             if(snapshot.data.docs.length > 0){
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    CarDataModel cars = CarDataModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      color: Colors.amber[100],
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(cars.brand,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        subtitle: Text(cars.name, overflow: TextOverflow.ellipsis,maxLines: 2,),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateCarScreen(cars)));
                        },
                      ),
                    );
                  }
                  );
             }else{
               return Center(
                 child: Text("No data"),
               );
             }
           }
           return Center(
             child: CircularProgressIndicator(),
           );
         },
       ),
       floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.blue[200],
         child: Icon(Icons.add),
         onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddCarScreen()));
         },
       ),
             drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "${currentUser.name} ${currentUser.email}",
                style: const TextStyle(fontSize: 25),
                ),
            ),
            
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
              },
            ),
          ],
        ),
      ),
    );
       
   
  }
  /*Future getData() async{
    var data = await FirebaseFirestore.instance
          .collection('car')
          .get();
    setState(() {
      
    });
  }*/
}