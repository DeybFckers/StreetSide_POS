import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/features/products/data/models/item_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';

class OrderRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<void> addOrder(OrderModel order, List<ItemModel> items) async{
    final db = await _database.database;

    await db.transaction((txn) async{
      final orderId = await txn.insert(OrderTable.OrderTableName, {
        OrderTable.OrderCustomer: order.name,
        OrderTable.OrderTotalAmount: order.totalAmount,
        OrderTable.OrderAmountGiven: order.amountGiven,
        OrderTable.OrderChange: order.change,
        OrderTable.OrderCreatedAT: order.createdAt,
      });

      for (final item in items) {
        await txn.insert(OrderTable.ItemTableName, {
          OrderTable.ItemOrder: orderId,
          OrderTable.ItemProduct: item.productId,
          OrderTable.ItemQuantity: item.quantity,
          OrderTable.ItemSubtotal: item.subTotal,
        });
      }
    });
  }

  Future<List<OrderModel>> getOrder() async{
    try{
      final db = await _database.database;
      final data = await db.query(OrderTable.OrderTableName);
      return data.map((e) => OrderModel.fromMap(e)).toList();

    }catch(e){
      print('Error getting order: $e');
      return [];
    }
  }
}