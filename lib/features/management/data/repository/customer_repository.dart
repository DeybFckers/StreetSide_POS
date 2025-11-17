import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';

class CustomerRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<List<OrderModel>> getOrders() async {
    try {
      final db = await _database.database;
      final result = await db.query(OrderTable.OrderTableName);
      return result.map((e) => OrderModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<void> updateCash(int orderId, double cash) async {
    try {
      final db = await _database.database;
      await db.update(
        OrderTable.OrderTableName,
        {OrderTable.OrderAmountGiven: cash},
        where: 'Order_Id = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('error cash update $e');
    }
  }

  Future<void> updateChange(int orderId, double change) async{
    try{
      final db = await _database.database;
      await db.update(OrderTable.OrderTableName, {
        OrderTable.OrderChange: change,
      },
        where: 'Order_Id = ?',
        whereArgs: [orderId],
      );
    }catch(e){
      print('error change update $e');
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      final db = await _database.database;
      await db.delete(
        OrderTable.OrderTableName,
        where: 'Order_Id = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error deleting order $e');
    }
  }
}
