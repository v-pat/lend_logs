

import 'dart:io';

import 'package:lend_logs/models/person.dart';
import 'package:lend_logs/models/transactions.dart';
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

  String db_path ='';
  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    db_path = join(directory.path, "lend_logs.db");
    return await openDatabase(db_path, version: 1,
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

  Future<void> deleteDatabase() =>
    databaseFactory.deleteDatabase(db_path);

   Future<List<Person>> retrievePersons() async {
    final Database db = await database;
    final List<Map<String, Object?>> queryResult = await db.query(personTable);
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<List<Transactions>> retrieveTransactionsByPerson(int person_id) async {
    final Database db = await database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery("SELECT * FROM "+transactionsTable+" WHERE " + "person_id" + " = " + person_id.toString(),null);
    return queryResult.map((e) => Transactions.fromMap(e)).toList();
  }

  Future<List<Person>> retrievePersonById(int person_id) async {
    final Database db = await database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery("SELECT * FROM "+personTable+" WHERE " + "id" + " = " + person_id.toString(),null);
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> insertTransaction(Transactions transactions) async {
    int result = 0;
    final Database db = await database;
      result = await db.insert(transactionsTable, Transactions.toMap(transactions),
          conflictAlgorithm: ConflictAlgorithm.replace);

    List<Person> p=[];
    int updateResult=0;
    if(result!=0){
      p = await retrievePersonById(transactions.personId);
      if(p.length>0){
        var val = (int.parse(p[0].finalAmount)+int.parse(transactions.amount)).toString();
          
          updateResult = await db.rawUpdate('''
            UPDATE $personTable 
            SET $personFinalAmountCol = ?
            WHERE $personIdCol = ?
            ''', 
            [val,transactions.personId]
          );
      }
    }
    return result;
  }

  Future<int> deleteTransaction(Transactions transactions) async {
    int result = 0;
    int updateResult = 0;
    final Database db = await database;
      result = await db.delete(transactionsTable, where:'date = ?',whereArgs: [Transactions.dateFormat.format(transactions.date)]);
    List<Person> p=[];
    if(result!=0){
     p = await retrievePersonById(transactions.personId);
      if(p.length>0){
        var val = (int.parse(p[0].finalAmount)-int.parse(transactions.amount)).toString();
          
          updateResult = await db.rawUpdate('''
            UPDATE $personTable 
            SET $personFinalAmountCol = ?
            WHERE $personIdCol = ?
            ''', 
            [val,transactions.personId]
          );
      }
    }
    return result;

  }
}