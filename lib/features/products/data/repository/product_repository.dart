import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/product_table.dart';
import 'package:coffee_pos/features/products/data/models/product_model.dart';

class ProductRepository{
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<void> addProduct(ProductModel product) async {
    try {
      final db = await _database.database;
      await db.insert(ProductTable.ProductTableName, {
        ProductTable.ProductName: product.name,
        ProductTable.ProductCategory: product.category,
        ProductTable.ProductPrice: product.price,
        ProductTable.ProductImage: product.imageUrl,
      });
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<List<ProductModel>> getProduct() async{
    try{
      final db = await _database.database;
      final data = await db.query(ProductTable.ProductTableName);
      return data.map((e) => ProductModel.fromMap(e)).toList();
    }catch(e){
      print('Error getting product: $e');
      return [];
    }
  }
}