import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchCarScreen extends StatefulWidget {
  const SearchCarScreen({ Key? key }) : super(key: key);

  @override
  State<SearchCarScreen> createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Details Page')),
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
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateCarScreen(cars)));
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
    );
  }
}

