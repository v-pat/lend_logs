import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransactionsPage extends StatefulWidget {
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _formKey = GlobalKey<FormState>();
  var transactionTypes = ["Paid", "Recieved"];
  String _chosenValue = "123";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Contact Name",
          ),
          Text("Contact number", style: TextStyle(fontSize: 14.0)),
        ],
      )),
      body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          height: MediaQuery.of(context).size.height * (0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("details"),
                              Text("date"),
                              Text("+-amount"),
                              IconButton(
                                  onPressed: () => {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add transaction"),
                content: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Brief Transaction Details"),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Transaction Amount"),
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: transactionTypes[0],
                                  groupValue: transactionTypes,
                                  onChanged: (value) {}),
                              Text('Paid', style: TextStyle(fontSize: 12.0)),
                              Radio(
                                  value: transactionTypes[1],
                                  groupValue: transactionTypes,
                                  onChanged: (value) {}),
                              Text('Recieved',
                                  style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                                onPressed: (){Navigator.pop(context);}, 
                                child: Text("cancel",style:TextStyle(color: Colors.black))
                              ),
                              SizedBox(width: 4.0,),
                              ElevatedButton(
                                onPressed: (){}, 
                                child: Text("Add")
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        },
      ),
    );
  }
}
