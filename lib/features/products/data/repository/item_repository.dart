import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/features/products/data/models/item_model.dart';

class ItemRepository{
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<List<ItemModel>> getItem() async{
    try{
      final db = await _database.database;
      final data = await db.query(OrderTable.ItemTableName);
      return data.map((e) => ItemModel.fromMap(e)).toList();
    }catch(e){
      print('Error getting product: $e');
      return [];
    }
  }
}