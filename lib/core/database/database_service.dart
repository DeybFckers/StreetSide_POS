import 'package:coffee_pos/core/database/order_table.dart';
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
    // await deleteDatabase(databasePath);

    final database =  await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version){
        //product table
        db.execute('''
        CREATE TABLE ${ProductTable.ProductTableName}(
        ${ProductTable.ProductID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProductTable.ProductName} TEXT,
        ${ProductTable.ProductCategory} TEXT CHECK (${ProductTable.ProductCategory} IN ('Coffee', 'Food', 'Drinks')) NOT NULL,
        ${ProductTable.ProductPrice} REAL NOT NULL,
        ${ProductTable.ProductImage} TEXT
        )
        ''');
        //order table
        db.execute('''
        CREATE TABLE ${OrderTable.OrderTableName}(
        ${OrderTable.OrderID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${OrderTable.OrderCustomer} TEXT,
        ${OrderTable.OrderTotalAmount} REAL NOT NULL,
        ${OrderTable.OrderAmountGiven} REAL,
        ${OrderTable.OrderChange} REAL,
        ${OrderTable.OrderType} TEXT CHECK (${OrderTable.OrderType} IN ('Dine In', 'Take Out')) NOT NULL,
        ${OrderTable.OrderPayment} TEXT CHECK(${OrderTable.OrderPayment} IN ('Cash', 'Gcash')) NOT NULL,
        ${OrderTable.OrderStatus} TEXT NOT NULL CHECK (${OrderTable.OrderStatus} IN ('In Progress', 'Completed')) DEFAULT 'In Progress',
        ${OrderTable.OrderCreatedAT} TEXT DEFAULT CURRENT_TIMESTAMP
        )
        ''');
        // order_item table
        db.execute('''
        CREATE TABLE ${OrderTable.ItemTableName}(
        ${OrderTable.ItemID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${OrderTable.ItemOrder} INTEGER NOT NULL,
        ${OrderTable.ItemProduct} INTEGER NOT NULL,
        ${OrderTable.ItemQuantity} INTEGER NOT NULL,
        ${OrderTable.ItemSubtotal} REAL NOT NULL,
        FOREIGN KEY (${OrderTable.ItemOrder}) REFERENCES ${OrderTable.OrderTableName}(${OrderTable.OrderID}),
        FOREIGN KEY (${OrderTable.ItemProduct}) REFERENCES ${ProductTable.ProductTableName}(${ProductTable.ProductID})
        ) 
        ''');
      }
    );
    return database;
  }

}