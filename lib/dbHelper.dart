

import 'dart:io';

import 'package:lend_logs/models/person.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  final String personTable = "person";
  final String transactionsTable = "transactions";

  final String personNameCol = "name";
  final String personIdCol = "id";
  final String personNumberCol = "number";
  final String personIsPaidCol = "is_paid";
  final String personFinalAmountCol = "final_amount";

  final String transactionsDetailsCol = "details";
  final String transactionsIdCol = "id";
  final String transactionsAmountCol = "amount";
  final String transactionsIsPaidCol = "is_paid";
  final String transactionsPersonIdCol = "person_id";
  final String transactionsDateCol = "date";


 DbHelper._();

  static final DbHelper db = DbHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabaseInstance();
    return _database!;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "lend_logs.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''create table $personTable(
        $personIdCol integer primary key autoincrement,
        $personNameCol text not null,
        $personNumberCol text not null,
        $personFinalAmountCol text not null,
        $personIsPaidCol integer default 0
      )''');

      await db.execute('''create table $transactionsTable(
        $transactionsIdCol integer primary key autoincrement,
        $transactionsDateCol text not null,
        $transactionsAmountCol text not null,
        $transactionsDetailsCol text not null,
        $transactionsIsPaidCol integer default 0,
        $transactionsPersonIdCol integer not null,
        FOREIGN KEY ($transactionsPersonIdCol) REFERENCES person($personIdCol) ON DELETE NO ACTION ON UPDATE NO ACTION
      )''');
    });
  }

  Future<int> inserTPersons(Person person) async {
    int result = 0;
    final Database db = await database;
      result = await db.insert(personTable, Person.toMap(person),
          conflictAlgorithm: ConflictAlgorithm.replace);
 
    return result;
  }

   Future<List<Person>> retrievePersons() async {
    final Database db = await database;
    final List<Map<String, Object?>> queryResult = await db.query(personTable);
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }
}