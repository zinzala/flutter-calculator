import 'package:flutter/material.dart';

import 'calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = '';   // . and 0-9
  String operator = '';  // + - * /
  String number2 = '';   // . and 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    '$number1$operator$number2'.isEmpty ? '0' : '$number1$operator$number2',
                    style: TextStyle(
                      fontSize: 51.0,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0 ? screenSize.width / 2 : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  // build and return button
  Widget buildButton(String value) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Material(
        color: getColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white38)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.50),
            ),
          ),
        ),
      ),
    );
  }

  // button colors
  Color getColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
      Btn.per,
      Btn.multiply,
      Btn.divide,
      Btn.subtract,
      Btn.add,
      Btn.calculate
    ].contains(value)
        ? Colors.orange
        : Colors.black87;
  }

  void onBtnTap(String value) {
    // on delete button tap
    if(value == Btn.del){
      delete();
      return;
    }

    // on clear button tap
    if(value == Btn.clr){
      clearAll();
      return;
    }

    // on percentage button tap
    if(value == Btn.per){
      convertToPercentage();
      return;
    }

    // on equal button tap
    if(value == Btn.calculate){
      calculate();
      return;
    }

    appendValue(value);
  }
  // calculate the equation
  void calculate(){
    if (number1.isEmpty) return;
    if (operator.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch(operator){
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";

      if(number1.endsWith('.0')){
        number1 = number1.substring(0,number1.length - 2);
      }

      operator = "";
      number2 = "";
    });
  }


  // finding percentage
  void convertToPercentage(){
    if(number1.isNotEmpty && operator.isNotEmpty && number2.isNotEmpty){
      // calculate the equation first
      calculate();
    }
    if(operator.isNotEmpty){
     // can not be converted for ex: 123+
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${number / 100}";
      operator = "";
      number2 = "";
    });
  }

  // clearing all values
  void clearAll(){
    setState(() {
      number1 = '';
      operator = '';
      number2 = '';
    });
  }

  // Deleting one character at the end
  void delete(){
    if(number2.isNotEmpty){
      number2 = number2.substring(0,number2.length - 1);
    }else if(operator.isNotEmpty){
      operator = '';
    }else if(number1.isNotEmpty){
      number1 = number1.substring(0,number1.length - 1);
    }

    setState(() {

    });
  }

  // appending value
  void appendValue(String value){
    // number1 operator number2
    // 11 + 12

    // for non-number buttons
    if(value != Btn.dot && int.tryParse(value) == null){

      if(operator.isNotEmpty && number2.isNotEmpty){
        // TODO: calculate equation
        calculate();
      }
      operator = value;
    }
    //based on variable we need to assign value to it
    // for number1
    
    else if(number1.isEmpty || operator.isEmpty){
      if(value == Btn.dot && number1.contains(Btn.dot)) return;
      if(value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)){  // number1.contains(Btn.n0)
        value = '0.';
      }

      number1 += value;
    }
    // for number2
    else if(number2.isEmpty || operator.isNotEmpty){
      if(value == Btn.dot && number2.contains(Btn.dot)) return;
      if(value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)){  // number2.contains(Btn.n0)
        value = '0.';
      }
      number2 += value;
    }

    setState(() {});
  }
}
