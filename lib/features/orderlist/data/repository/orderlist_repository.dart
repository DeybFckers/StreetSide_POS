import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/features/orderlist/data/models/orderlist_model.dart';

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
}
