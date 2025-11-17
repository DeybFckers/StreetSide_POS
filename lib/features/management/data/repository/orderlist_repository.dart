import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/features/management/data/models/orderlist_model.dart';

class OrderlistRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<Map<int, List<orderListModel>>> getGroupedOrders() async {
    try {
      final db = await _database.database;
      final data = await db.query(OrderTable.ListTableName);
      final list = data.map((e) => orderListModel.fromMap(e)).toList();

      final Map<int, List<orderListModel>> groupedOrders = {};
      for (var item in list) {
        if (item.OrderId != null) {
          groupedOrders.putIfAbsent(item.OrderId!, () => []).add(item);
        }
      }

      return groupedOrders;
    } catch (e) {
      print('Error getting grouped orders: $e');
      return {};
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async{
    try{
      final db = await _database.database;
      await db.update(OrderTable.OrderTableName,
        {OrderTable.OrderStatus: status},
        where: 'Order_Id = ?',
        whereArgs: [orderId]
      );
    }catch(e){
      print('error status update $e');
    }
  }

  Future<void> updateOrderProduct(int itemId, int productId) async {
    try {
      final db = await _database.database;
      await db.update(
        OrderTable.ItemTableName,
        {OrderTable.ItemProduct: productId},
        where: 'Item_Id = ?',
        whereArgs: [itemId],
      );
    } catch (e) {
      print('error product update $e');
    }
  }

  Future<void> updateOrderQuantity(int itemId, int quantity) async {
    try {
      final db = await _database.database;
      await db.update(
        OrderTable.ItemTableName,
        {OrderTable.ItemQuantity: quantity},
        where: 'Item_Id = ?',
        whereArgs: [itemId],
      );
    } catch (e) {
      print('error quantity update $e');
    }
  }

  Future<void> updateOrderSubTotal(int itemId, double subtotal) async {
    try {
      final db = await _database.database;
      await db.update(
        OrderTable.ItemTableName,
        {OrderTable.ItemSubtotal: subtotal},
        where: 'Item_Id = ?',
        whereArgs: [itemId],
      );
    } catch (e) {
      print('error subtotal update $e');
    }
  }

  Future<void> updateTotal(int orderId, double total) async{
    try{
      final db = await _database.database;
      await db.update(OrderTable.OrderTableName, {
        OrderTable.OrderTotalAmount: total,
      },
        where: 'Order_Id = ?',
        whereArgs: [orderId]
      );
    }catch(e){
      print('error total update $e');
    }
  }
  
  Future<void> deleteOrderItem(int ItemId) async{
    try{
      final db = await _database.database;
      await db.delete(OrderTable.ItemTableName,
      where: 'Item_Id = ?',
        whereArgs: [ItemId]
      );
    }catch(e){
      print('error delete $e');
    }
  }

}
