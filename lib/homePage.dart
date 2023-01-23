
import 'package:flutter/material.dart';
import 'package:lend_logs/transactions.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Lend Logs")),
      body: Padding(
        padding:EdgeInsets.all(4.0) ,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder:  (BuildContext context, int index) {
                  return ListTile(
                    title: Text("Contact "+index.toString()),
                    subtitle: Text(index.toString()+"000000000"),
                    trailing: Text("amount"),
                    onTap: () => {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new TransactionsPage("Contact "+index.toString(),index.toString()+"000000000"))),
                    },
                  );
                }
              )
            )
          ]
        )
      ,),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          
        }
      )
    );
  }
}