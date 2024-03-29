import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lend_logs/dbHelper.dart';
import 'package:lend_logs/homePage.dart';
import 'package:lend_logs/models/transactions.dart';
import 'package:lend_logs/utils.dart';

class TransactionsPage extends StatefulWidget {
  final String contactName;
  final int personId;
  final String contactNumber;
  final int contactId = 122;
  TransactionsPage(this.personId, this.contactName, this.contactNumber);
  @override
  State<TransactionsPage> createState() => _TransactionsPageState(
      this.personId, this.contactName, this.contactNumber);
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _formKey = GlobalKey<FormState>();
  var transactionTypes = ["Paid", "Recieved"];
  final String contactName;
  final int personId;
  final int contactId = 122;
  final String contactNumber;
  late List<Transactions> transactions = [];
  _TransactionsPageState(this.personId, this.contactName, this.contactNumber);

  String selectedTransactionType = "";
  @override
  void initState() {
    getinitialData();
    super.initState();
  }

  getinitialData() async {
    transactions =
        await DbHelper.db.retrieveTransactionsByPerson(this.personId);
    setState(() {
      this.transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    child: Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: ((context) => new HomePage())));
              }),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                this.contactName,
              ),
              Text(this.contactNumber, style: TextStyle(fontSize: 14.0)),
            ],
          )),
      body: transactions.length>0?Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            children: [
              Expanded(
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (BuildContext context, int i) {
                      return GestureDetector(
                        child: Card(
                          child: Container(
                            height: MediaQuery.of(context).size.height * (0.07),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      transactions[i].details,
                                      overflow: TextOverflow.ellipsis,
                                    )), // Text(Transactions.dateFormat
                                //     .format(transactions[i].date)),
                                Text(
                                  transactions[i].amount,
                                  style: TextStyle(
                                      color:
                                          transactions[i].amount.contains('-')
                                              ? Colors.red
                                              : Colors.green,
                                      fontSize: 14),
                                ),
                                // IconButton(
                                //     onPressed: () => {},
                                //     icon: Icon(
                                //       Icons.delete,
                                //       color: Colors.red,
                                //     ))
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Transaction details",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            DbHelper.db.deleteTransaction(
                                                transactions[i]);
                                            setState(
                                              () {
                                                getinitialData();
                                              },
                                            );
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                  content: Padding(
                                    padding: EdgeInsets.all(1.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Date :",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                Transactions.dateFormat.format(
                                                    transactions[i].date),
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Amount :",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                transactions[i].amount,
                                                style: TextStyle(
                                                    color: transactions[i]
                                                            .amount
                                                            .contains('-')
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Details :",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  transactions[i].details,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          )):Center(
        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("There are no transactions yet."),
                          Text("Click on add button to new transaction",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.colortheme,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              bool isPaidvalue = false;
              final detailsController = TextEditingController();
              final amountController = TextEditingController();
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text("Add transaction"),
                  content: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: detailsController,
                                decoration: InputDecoration(
                                  label: Text("Brief Transaction Details"),
                                ),
                                maxLength: 150,
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Please enter valid details';
                                    } else if (value.length < 5) {
                                      return 'minimun 5 letters required';
                                    } else if (value.length > 150) {
                                      return 'maximum 150 letters allowed';
                                    }
                                  } else {
                                    return 'Please enter valid details';
                                  }
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: amountController,
                                decoration: InputDecoration(
                                  label: Text("Transaction Amount"),
                                ),
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Enter a valid amount';
                                    } else if (value.length > 6) {
                                      return 'upto 6 digits are allowed';
                                    } else {
                                      return null;
                                    }
                                  } else {
                                    return 'Enter a valid amount';
                                  }
                                },
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Color(0xFF1f1053),
                                      value: isPaidvalue,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            isPaidvalue = value;
                                          });
                                        }
                                      },),
                                  Text('Paid',
                                      style: TextStyle(fontSize: 12.0)),
                                  Checkbox(
                                    checkColor: Color(0xFF1f1053),
                                      value: !isPaidvalue,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            isPaidvalue = !value;
                                          });
                                        }
                                      }),
                                  Text('Recieved',
                                      style: TextStyle(fontSize: 12.0)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("cancel",
                                          style:
                                              TextStyle(color: Colors.black))),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          var amt = isPaidvalue
                                              ? '-' +
                                                  amountController.text
                                                      .toString()
                                              : '+' +
                                                  amountController.text
                                                      .toString();
                                          var t = new Transactions(
                                            detailsController.text,
                                            amt,
                                            new DateTime.now(),
                                            // isPaidvalue,
                                            this.personId,
                                          );
                                          DbHelper.db.insertTransaction(t);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text("Add")),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                );
              });
            },
          ).then((value) => {this.getinitialData()});
        },
      ),
    ),
    onWillPop: ()async{
       Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new HomePage()));
        return false;
      }
    );
  }
}
