
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


  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
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

      await db.execute('''create table $TransactionsTable(
        $TransactionsIdCol integer primary key autoincrement,
        $TransactionsDateCol text not null,
        $TransactionsAmountCol text not null,
        $transactionsDetailsCol text not null,
        $transactionsIsPaidCol integer default 0,
        FOREIGN KEY (transactionsPersonIdCol) REFERENCES person(id)
      )''');
    });
  }
}