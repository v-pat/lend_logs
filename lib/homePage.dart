import 'package:flutter/material.dart';
import 'package:lend_logs/dbHelper.dart';
import 'package:lend_logs/models/person.dart';
import 'package:lend_logs/transactionsPage.dart';
import 'package:contacts_service/contacts_service.dart';
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
  }

  void takeContacPermission() async {
    if (await Permission.contacts.isGranted) {
      contacts = await ContactsService.getContacts(withThumbnails: false);
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
        appBar: AppBar(title: Text("Lend Logs")),
        body: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(children: [
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: persons.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: Text(persons[i].name),
                        subtitle: Text(persons[i].number),
                        trailing: Text(
                            (persons[i].isPaid ? '- ' : '+ ') +
                                persons[i].finalAmount,
                            style: TextStyle(
                                color: persons[i].isPaid
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 20)),
                        onTap: () => {
                          print(persons[i].personId),
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new TransactionsPage(
                                  persons[i].personId,persons[i].name, persons[i].number))),
                        },
                      );
                    }))
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                this.isLoading = true;
              });
              this.takeContacPermission();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text(
                          "Start Transaction Log",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        content: Padding(
                            padding: EdgeInsets.all(1.0),
                            child: SingleChildScrollView(
                                child: Column(children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text("Search contact"),
                                ),
                              ),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: contacts.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return ListTile(
                                      title: Text(contacts![i].displayName!),
                                      subtitle: Text(contacts[i]
                                          .phones![0]
                                          .value!
                                          .toString()),
                                      onTap: () async {
                                        var p = Person(
                                          contacts![i].displayName!,
                                          contacts[i]
                                              .phones![0]
                                              .value!
                                              .toString(),
                                          '0',
                                          true,
                                        );
                                        if ((persons
                                                .firstWhere(
                                                    (el) =>
                                                        el.number == p.number,
                                                    orElse: () => Person(
                                                        "", "", "", true))
                                                .name ==
                                            "")) {
                                          DbHelper.db.inserTPersons(p);
                                        } else {
                                          var snackBar = SnackBar(content: Text('You already have history of transaction with this person'));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }

                                        persons =
                                            await DbHelper.db.retrievePersons();
                                        setState(() {
                                          this.persons = persons;
                                        });
                                      },
                                    );
                                  }),
                            ]))));
                  });
            }));
  }
}
