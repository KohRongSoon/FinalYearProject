import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({ Key? key }) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda1.jpg?alt=media&token=17116b47-364b-4b8c-aa38-72503208f4aa',
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda2.jpg?alt=media&token=23cfb08c-57d1-40b9-8911-c487b137f0e7',
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda3.jpg?alt=media&token=ea968a1a-2173-4ca6-ab74-cbfdeb91bfb1',
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda4.jpg?alt=media&token=922fbc03-a649-4e3a-a8ce-ba1e8e5b8513',
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda5.jpg?alt=media&token=e843c3d0-10aa-4045-be3a-78665447dbef',
  'https://firebasestorage.googleapis.com/v0/b/carmobileapp-c9675.appspot.com/o/example%2Fhonda6.jpg?alt=media&token=ad60df52-32f6-40ef-89e3-09d871372d1f'
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details"),
        centerTitle: true,
        
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child:SingleChildScrollView(
          child: Column(
          children: [
            CarouselSlider.builder(
            itemCount: imgList.length,
            options: CarouselOptions(
            height: 200,
            //autoPlay: true,
            //autoPlayInterval: Duration(seconds: 5),
            //pageSnapping: false,
            viewportFraction: 1,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            //enableInfiniteScroll: false,
            onPageChanged: (index, reason) => 
              setState(() => currentIndex = index),
            ),
              itemBuilder: (context,index,realIndex){
                final urlImage = imgList[index];

                return buildImage(urlImage, index);
              },
            ),
            const SizedBox(height: 20),
            buildIndicator(),

            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                child: Column(children: [ Row(children:[ 
            Text('Car Brand: Honda',
            style: TextStyle(height: 1.5, letterSpacing: 1.0)),
            ]),
      
            const SizedBox(height: 20),
            Row(children: [
              Text('Car Name: Honda Civic 2020',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))
            ]),
            
            const SizedBox(height: 20),
            Row(children: [ Text('Car Year: May 2020',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],),

            const SizedBox(height: 20),
            Row(children: [Text('Car Safety: Safety',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],),

            const SizedBox(height: 20),
            Row(children: [Text('Car Power: 200',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],),

            const SizedBox(height: 20),
            Row(children: [Text('Car Price: RM 75000',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],),

            const SizedBox(height: 20),
            Row(children: [Text('Car Engine: Honda ',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],),

            const SizedBox(height: 20),
            Row(children: [Text('Car Body: Sedan',
            style: TextStyle(height: 1.5, letterSpacing: 1.0))],), ],),
              ),
              ),
           ],
          ),
        )
        
         
        ),
      );
  }
  Widget buildImage(String urlImage, int index) => Container(
        margin:  EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green[100],
        child: Image.network(
            urlImage,
            fit: BoxFit.cover,
          ),
      );

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: imgList.length,
      );
  }
}