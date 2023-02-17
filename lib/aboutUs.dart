
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        title:  Text("Pay Logs"),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Developer Contact :"),
            Text('vpat.getinfo@gmail.com',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),)
          ]),
        ),
      ),
    );
  }

}