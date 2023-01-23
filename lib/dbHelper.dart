
class DbHelper{

 DbHelper._();

  static final DbHelper db = DbHelper._();


  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Person ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "city TEXT"
          ")");
    });
  }
}