import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/core/database/product_table.dart';
import 'package:coffee_pos/features/management/data/models/orderlist_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';

class ManagementRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<List<ProductModel>> getManagementProduct() async {
    try {
      final db = await _database.database;
      final data = await db.query(ProductTable.ProductTableName);
      return data.map((e) => ProductModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<List<OrderModel>> getManagementOrder() async {
    try {
      final db = await _database.database;
      final data = await db.query(OrderTable.OrderTableName);
      return data.map((e) => OrderModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<List<orderListModel>> getManagementOrderList() async {
    try {
      final db = await _database.database;
      final data = await db.query(OrderTable.ListTableName);
      return data.map((e) => orderListModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting order list: $e');
      return [];
    }
  }
}
