import 'package:carmobileapplication/models/car_data_model.dart';
import 'package:flutter/material.dart';

import 'database_manager.dart';
import 'reuse_input.dart';

class UpdateCarScreen extends StatefulWidget {
  CarDataModel cars;
  UpdateCarScreen(this.cars);

  @override
  _UpdateCarScreenState createState() => _UpdateCarScreenState();
}

class _UpdateCarScreenState extends State<UpdateCarScreen> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    brandController.text = widget.cars.brand;
    nameController.text = widget.cars.name;
    priceController.text = '${widget.cars.price}';
    yearController.text = widget.cars.year;
    bodyController.text = widget.cars.body;
    engineController.text = widget.cars.engine;
    powerController.text = widget.cars.power;
    safetyController.text = widget.cars.safety;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Car Info'),
          backgroundColor: Colors.blue[900],
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert!'),
                          content: const Text(
                              'Are you confirm to delete this car information?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No')),
                            TextButton(
                                onPressed: () async {
                                  await DatabaseManager()
                                      .deleteCar(widget.cars.carId);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('Yes')),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.delete_forever_outlined,
                    color: Colors.white))
          ],
        ),
        backgroundColor: Colors.pink[100],
        body: loading
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Car Brand'),
                              brandInput,
                              SizedBox(height: 10),
                              Text('Car Name'),
                              nameInput,
                              SizedBox(height: 10),
                              Text('Car Price'),
                              priceInput,
                              SizedBox(height: 10),
                              Text('Car Launched Year'),
                              yearInput,
                              SizedBox(height: 10),
                              Text('Car Body Type'),
                              bodyInput,
                              SizedBox(height: 10),
                              Text('Car Engine'),
                              engineInput,
                              SizedBox(height: 10),
                              Text('Car Power'),
                              powerInput,
                              SizedBox(height: 10),
                              Text('Car Safety Features'),
                              safetyInput,
                              SizedBox(height: 20),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      await DatabaseManager().updateCar(
                                          widget.cars.carId,
                                          brandController.text,
                                          nameController.text,
                                          int.parse(priceController.text),
                                          yearController.text,
                                          bodyController.text,
                                          engineController.text,
                                          powerController.text,
                                          safetyController.text);
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Update Car Info",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red[200]),
                                ),
                              )
                            ]),
                      )),
                ),
              )));
  }
}
