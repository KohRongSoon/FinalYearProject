import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final formKey = GlobalKey<FormState>();

  //controller
  final TextEditingController priceController = new TextEditingController();
  final TextEditingController paymentController = new TextEditingController();
  final TextEditingController periodController = new TextEditingController();
  final TextEditingController interestController = new TextEditingController();

  double result = 0;

  @override
  Widget build(BuildContext context) {
    final priceInput = TextFormField(
      autofocus: false,
      controller: priceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Car price can't be empty.");
        }
        if (!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) {
          return ("Please enter positive integer only.");
        }
      },
      onSaved: (value) {
        priceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final downPaymentInput = TextFormField(
      autofocus: false,
      controller: paymentController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Down payment can't be empty.");
        }

        if (!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) {
          return ("Please enter positive integer only.");
        }
      },
      onSaved: (value) {
        paymentController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final yearInput = TextFormField(
      autofocus: false,
      controller: periodController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Loan period can't be empty");
        }

        if (!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) {
          return ("Please enter positive integer only.");
        }
      },
      onSaved: (value) {
        periodController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final interestInput = TextFormField(
      autofocus: false,
      controller: interestController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Interest rate can't be empty");
        }

        if (!RegExp(r'^[1-9]+[0-9]*$').hasMatch(value)) {
          return ("Please enter positive integer only.");
        }
      },
      onSaved: (value) {
        interestController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final calculateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.lightGreen[100],
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          //minWidth: MediaQuery.of(context).size.width,
          minWidth: 200.0,
          onPressed: () {
            calculateCarLoan();
          },
          child: const Text(
            "Calculate",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.black),
          )),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Car Loan Calculator')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Car Price (RM)'),
                priceInput,
                SizedBox(height: 20),
                Text('Down Payment (RM)'),
                downPaymentInput,
                SizedBox(height: 20),
                Text('Loan Period (Years)'),
                yearInput,
                SizedBox(height: 20),
                Text('Interest Rate (%)'),
                interestInput,
                SizedBox(height: 20),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      calculateButton,
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    height: 100,
                    color: Colors.brown[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Result: RM ${result.toStringAsFixed(2)} per month',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateCarLoan() {
    if (formKey.currentState!.validate()) {
      double? price = double.tryParse(priceController.text);
      double? downPayment = double.tryParse(paymentController.text);
      double? loanPeriod = double.tryParse(periodController.text);
      double? interestRate = double.tryParse(interestController.text);
      double fullPayment = price! - downPayment!;
      double totalInterest = interestRate! / 100 * loanPeriod! * fullPayment;
      print(fullPayment);
      print(totalInterest);

      double loan = (fullPayment + totalInterest) / (loanPeriod * 12);

      setState(() {
        result = loan;
      });
    }
  }
}
