import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('About Us')),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'This car application was developed tp help the users to make car comparisons before purchasing a new car. By making car comparisons, it will help you to find the cars that suitbale to you.',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ));
  }
}
