import 'package:flutter/material.dart';
class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Widget> myList = [];
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            myList.add(Text("$counter",style: TextStyle(fontSize: 30),));
            counter ++;
            print(myList);
            print(counter);
          });
        },
      ),
      appBar: AppBar(title: Text("test"),),
      body: Center(
        child: ListView(
          children: myList,
        ),
      ),
    );
  }
}
