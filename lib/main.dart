import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      home: Wrapper(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String display = "0";
  String expression = "";

  ContextModel cm = ContextModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Calculator'),
      ),
      body: LayoutBuilder(builder: (context, size) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display numbers
              Container(
                height: size.maxHeight * 0.2,
                alignment: Alignment.centerRight,
                child: Text(
                  display,
                  softWrap: true,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: size.maxWidth / 4,
                      height: size.maxHeight * 0.12,
                      child: operatorBtn(label: "C")),
                  SizedBox(
                      width: size.maxWidth / 4,
                      height: size.maxHeight * 0.12,
                      child: operatorBtn(label: "B")),
                 
                  SizedBox(
                      width: size.maxWidth / 3,
                      height: size.maxHeight * 0.12,
                      child: operatorBtn(label: "=")),
                ],
              ),
              // Expanded(child: Divider()),
              Expanded(
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  children: [
                    // Row 1

                    numBtn(label: "7"),
                    numBtn(label: "8"),
                    numBtn(label: "9"),
                    operatorBtn(label: "×"),
                    // Row 2
                    numBtn(label: "4"),
                    numBtn(label: "5"),
                    numBtn(label: "6"),
                    operatorBtn(label: "÷"),
                    // Row 3
                    numBtn(label: "1"),
                    numBtn(label: "2"),
                    numBtn(label: "3"),
                    operatorBtn(label: "-"),
                    numBtn(label: "0"),
                    numBtn(label: "."),
                    numBtn(label: "00"),
                    operatorBtn(label: "+"),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

//Number Button Widget
  Widget numBtn({required String label}) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (display == "0") {
            display = label;
          } else {
            display = display + label;
          }
        });
      },
      style: TextButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
      ),
      child: Text(label, style: TextStyle(fontSize: 30, color: Colors.black)),
    );
  }

//Operator Button Widget
  Widget operatorBtn({required String label}) {
    return TextButton(
        onPressed: () {
          if (display == "0") {
            return;
          }
          setState(() {
            switch (label) {
              case "C":
                display = "0";
                expression = "";

                break;
              case "B":
                display = display.substring(0, display.length - 1);
                break;
              case "=":
                expression = display;
                expression = expression.replaceAll("×", "*");
                expression = expression.replaceAll("÷", "/");
                try {
                  Parser p = Parser();
                  var exp = p.parse(expression);
                  display = '${exp.evaluate(EvaluationType.REAL, cm)}';
                  // (exp.evaluate(EvaluationType.REAL, cm) as double)
                  //     .toString();
                } catch (e) {
                  display = "Error";
                }
                break;

              default:
                if (display == "") {
                  break;
                } else {
                  display = display + label;
                }
            }
          });
        },
        style: TextButton.styleFrom(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor:
              label == "=" ? Theme.of(context).primaryColor : Colors.white,
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 30,
                color: label == "="
                    ? Colors.white
                    : Theme.of(context).primaryColor)));
  }
}
