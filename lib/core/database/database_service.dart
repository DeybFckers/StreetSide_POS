import 'package:coffee_pos/core/database/product_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StreetSideDatabase{
  static Database? _db;
  static final StreetSideDatabase instance = StreetSideDatabase._internal();

  StreetSideDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "streetside_db.db");

    final database =  await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version){
        db.execute('''
        CREATE TABLE ${ProductTable.ProductTableName}(
        ${ProductTable.ProductID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProductTable.ProductName} TEXT,
        ${ProductTable.ProductCategory} TEXT CHECK (${ProductTable.ProductCategory} IN ('Coffee', 'Food', 'Drinks')) NOT NULL,
        ${ProductTable.ProductPrice} REAL NOT NULL,
        ${ProductTable.ProductImage} TEXT
        )
        ''');
      }
    );
    return database;
  }

}