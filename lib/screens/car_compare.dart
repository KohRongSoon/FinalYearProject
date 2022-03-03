import 'package:flutter/material.dart';

class CompareCarScreen extends StatefulWidget {
  const CompareCarScreen({ Key? key }) : super(key: key);

  @override
  State<CompareCarScreen> createState() => _CompareCarScreenState();
}

class _CompareCarScreenState extends State<CompareCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Compare Page')),
    );
  }
}