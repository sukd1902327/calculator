import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var question = '';
  var answer = '0';
  
  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '9', '8', '7', 'x',
    '6', '5', '4', '-',
    '3', '2', '1', '+',
    '0', '.', '00', '=',
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: height * 0.05,),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(question, style: const TextStyle(fontSize: 22, letterSpacing: 1.0),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(answer, style: const TextStyle(fontSize: 30, letterSpacing: 1.0),),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
                itemBuilder: (BuildContext context, int index) {
                  
                  //clear button
                  if(index == 0){
                    return MyButton(
                      onTap: (){
                        setState(() {
                          question = '';
                          answer = '0';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.amber,
                      textColor:Colors.white,
                    );
                  }
                  //delete button
                  else if (index == 1){
                    return MyButton(
                      onTap: (){
                        setState(() {
                          question = question.substring(0, question.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.red,
                      textColor:Colors.white,
                    );
                  } 
                  //equal button
                  else if (index == buttons.length-1){
                    return MyButton(
                      onTap: (){
                        setState(() {
                          calculation();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.deepPurple,
                      textColor:Colors.white,
                    );
                  }                  
                  //rest of buttons
                  else{
                    return MyButton(
                      onTap: (){
                        setState(() {
                          question += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index]) ?Colors.deepPurple : Colors.deepPurple[50],
                      textColor: isOperator(buttons[index]) ?Colors.white : Colors.deepPurple,
                    );
                  }
              }),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x){
    if(x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=' ) {
      return true;
    }
    return false;
  }

  void calculation(){
    String finalQuestion = question;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
}
