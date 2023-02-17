import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lend_logs/aboutUs.dart';
import 'package:lend_logs/dbHelper.dart';
import 'package:lend_logs/models/person.dart';
import 'package:lend_logs/transactionsPage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:lend_logs/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? db;
  late List<Person> persons = [];
  late List tempPersons = [];
  late List<Person> tempPersons2;
  List<Contact> contacts = [];
  bool isLoading = false;
  TextEditingController searchContactController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    getPersons();
    super.initState();
  }

  getPersons() async {
    persons = await DbHelper.db.retrievePersons();

    setState(() {
      this.persons = persons;
    });
    takeContacPermission();
  }

  void takeContacPermission() async {
    if (await Permission.contacts.isGranted) {
      searchContactController.clear();
      contacts = await ContactsService.getContacts(withThumbnails: false);
      List<Contact> tempContacts = contacts;
      contacts = [];
      tempContacts.forEach((element) {
        if (!(element.phones!.length < 1 ||
            element.phones![0].value == null ||
            element.displayName == '')) {
          contacts.add(element);
        }
      });
      setState(() {
        this.isLoading = false;
      });
    } else {
      await Permission.contacts.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Image.asset('assets/images/logo_appbar.png'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pay Logs"),
              IconButton(
                tooltip: "About Us",
                onPressed: (){
                Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new AboutUs()));
              }, 
              icon: Icon(Icons.info))
            ]
          ),
          
        ),
        body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(children: [
            Expanded(
                child:persons.length>0? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: persons.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: Text(persons[i].name),
                        subtitle: Text(persons[i].number),
                        trailing: Text(persons[i].finalAmount,
                            style: TextStyle(
                                color: persons[i].finalAmount.contains('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 20)),
                        onTap: () => {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new TransactionsPage(
                                  persons[i].personId,
                                  persons[i].name,
                                  persons[i].number))),
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Text(
                                      "Are You sure you want to delete all transaction logs with this person ?"),
                                  icon: Icon(Icons.delete),
                                  iconColor: Colors.red,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        DbHelper.db.deletePerson(persons[i]);
                                        getPersons();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              }));
                        },
                      );
                    }):
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("There are no transaction logs yet."),
                          Text("Click on add button to start transaction logs",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ))
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Utils.colortheme,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this.isLoading = true;
              });
              this.takeContacPermission();
              List<Contact> _contacts = contacts;
              bool iskeyboardopen =false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                          scrollable: true,
                          title: Text(
                            "Start Transaction Log",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          content: Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Column(children: [
                                TextFormField(
                                  controller: searchContactController,
                                  onChanged: (value) {
                                    var c = contacts
                                        .where((element) => element!
                                            .displayName!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                    setState(
                                      () {
                                        _contacts = c;
                                      },
                                    );
                                  },
                                  onTap: () {
                                     setState(
                                      () {
                                        iskeyboardopen = true;
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    label: Text("Search contact"),
                                  ),
                                ),
                                Container(
                                  height:MediaQuery.of(context).size.height / 3,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: _contacts.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return ListTile(
                                              title: Text(
                                                  _contacts![i].displayName!),
                                              subtitle: Text(_contacts[i]
                                                  .phones![0]
                                                  .value!
                                                  .toString()),
                                              onTap: () async {
                                                var p = Person(
                                                  _contacts![i].displayName!,
                                                  _contacts[i]
                                                      .phones![0]
                                                      .value!
                                                      .toString(),
                                                  '0',
                                                  true,
                                                );
                                                if ((persons
                                                        .firstWhere(
                                                            (el) =>
                                                                el.number ==
                                                                p.number,
                                                            orElse: () =>
                                                                Person("", "",
                                                                    "", true))
                                                        .name ==
                                                    "")) {
                                                  DbHelper.db.inserTPersons(p);
                                                } else {
                                                  var snackBar = SnackBar(
                                                      content: Text(
                                                          'You already have history of transaction with this person'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }

                                                this.getPersons();
                                                Navigator.pop(context);
                                              },
                                            );
                                          })),
                              ])));
                    });
                  });
            }));
  }
}
