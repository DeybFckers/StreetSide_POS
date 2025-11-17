import 'package:coffee_pos/core/database/analytics_table.dart';
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
        ${OrderTable.OrderType} TEXT CHECK (${OrderTable.OrderType} IN ('Dine In', 'Take Out', 'Delivery')) NOT NULL,
        ${OrderTable.OrderPayment} TEXT CHECK(${OrderTable.OrderPayment} IN ('Cash', 'Gcash')) NOT NULL,
        ${OrderTable.OrderStatus} TEXT NOT NULL CHECK (${OrderTable.OrderStatus} IN ('In Progress', 'Completed', 'Refund')) DEFAULT 'In Progress',
        ${OrderTable.OrderDiscount} INTEGER NOT NULL DEFAULT 0,
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
        //getOrdersWithItems()
        // db.execute('DROP VIEW IF EXISTS ${OrderTable.ListTableName}');
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${OrderTable.ListTableName} AS
        SELECT 
          o.${OrderTable.OrderID} as orderId,
          o.${OrderTable.OrderCustomer} as Customer_Name,
          o.${OrderTable.OrderTotalAmount} as Total_Amount,
          o.${OrderTable.OrderAmountGiven} as Amount_Given,
          o.${OrderTable.OrderChange} as Change,
          o.${OrderTable.OrderType} as Order_Type,
          o.${OrderTable.OrderPayment} as Payment_Method,
          o.${OrderTable.OrderStatus} as Status,
          o.${OrderTable.OrderDiscount} as Discounted,
          o.${OrderTable.OrderCreatedAT} as Date,
          p.${ProductTable.ProductID} as productId,
          p.${ProductTable.ProductName} as Product_Name,
          p.${ProductTable.ProductImage} as Product_Image,
          i.${OrderTable.ItemID} as itemId,
          i.${OrderTable.ItemQuantity} as Quantity,
          i.${OrderTable.ItemSubtotal} as SubTotal
          FROM ${OrderTable.OrderTableName} o
          JOIN ${OrderTable.ItemTableName} i
            ON o.${OrderTable.OrderID} = i.${OrderTable.ItemOrder}
          JOIN ${ProductTable.ProductTableName} p
            ON i.${OrderTable.ItemProduct} = p.${ProductTable.ProductID};
        ''');
        // View: Daily sales analytics
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${AnalyticsTable.DailySalesTableName} AS
        SELECT 
          date(${OrderTable.OrderCreatedAT}) AS Sale_Date,
          SUM(${OrderTable.OrderTotalAmount}) AS Total_Sales,
          COUNT(${OrderTable.OrderID}) AS Total_Orders
        FROM ${OrderTable.OrderTableName}
        WHERE ${OrderTable.OrderStatus} = 'Completed'
        GROUP BY date(${OrderTable.OrderCreatedAT})
        ORDER BY date(${OrderTable.OrderCreatedAT}) DESC;
        ''');
        // View: Weekly sales analytics
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${AnalyticsTable.WeeklySalesTableName} AS
        SELECT 
          strftime('%Y-%W', ${OrderTable.OrderCreatedAT}) AS Week,
          SUM(${OrderTable.OrderTotalAmount}) AS Total_Sales,
          COUNT(${OrderTable.OrderID}) AS Total_Orders
        FROM ${OrderTable.OrderTableName}
        WHERE ${OrderTable.OrderStatus} = 'Completed'
        GROUP BY strftime('%Y-%W', ${OrderTable.OrderCreatedAT})
        ORDER BY Week DESC;
        ''');
        // View: Monthly sales analytics
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MontlySalesTableName} AS
        SELECT 
          strftime('%Y-%m', ${OrderTable.OrderCreatedAT}) AS Month,
          SUM(${OrderTable.OrderTotalAmount}) AS Total_Sales,
          COUNT(${OrderTable.OrderID}) AS Total_Orders
        FROM ${OrderTable.OrderTableName}
        WHERE ${OrderTable.OrderStatus} = 'Completed'
        GROUP BY strftime('%Y-%m', ${OrderTable.OrderCreatedAT})
        ORDER BY Month DESC;
        ''');
        // View: Top selling products
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${AnalyticsTable.TopSellingTableName} AS
        SELECT 
          p.${ProductTable.ProductName} AS Product_Name,
          SUM(i.${OrderTable.ItemQuantity}) AS Total_Sold,
          SUM(i.${OrderTable.ItemSubtotal}) AS Total_Revenue
        FROM ${OrderTable.ItemTableName} i
        JOIN ${ProductTable.ProductTableName} p
          ON i.${OrderTable.ItemProduct} = p.${ProductTable.ProductID}
        JOIN ${OrderTable.OrderTableName} o
          ON i.${OrderTable.ItemOrder} = o.${OrderTable.OrderID}
        WHERE o.${OrderTable.OrderStatus} = 'Completed'
        GROUP BY i.${OrderTable.ItemProduct}
        ORDER BY Total_Sold DESC;
        ''');
        // View: Revenue by category
        db.execute('''
        CREATE VIEW IF NOT EXISTS ${AnalyticsTable.CategoryRevenueTableName} AS
        SELECT 
          p.${ProductTable.ProductCategory} AS Category,
          SUM(i.${OrderTable.ItemSubtotal}) AS Total_Revenue,
          COUNT(DISTINCT i.${OrderTable.ItemOrder}) AS Total_Orders
        FROM ${OrderTable.ItemTableName} i
        JOIN ${ProductTable.ProductTableName} p
          ON i.${OrderTable.ItemProduct} = p.${ProductTable.ProductID}
        JOIN ${OrderTable.OrderTableName} o
          ON i.${OrderTable.ItemOrder} = o.${OrderTable.OrderID}
        WHERE o.${OrderTable.OrderStatus} = 'Completed'
        GROUP BY p.${ProductTable.ProductCategory}
        ORDER BY Total_Revenue DESC;
        ''');

      }
    );
    return database;
  }

}