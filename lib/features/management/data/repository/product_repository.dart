import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/product_table.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';

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

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final db = await _database.database;
    final data = await db.query(
      ProductTable.ProductTableName,
      where: '${ProductTable.ProductCategory} = ?',
      whereArgs: [category],
    );
    return data.map((e) => ProductModel.fromMap(e)).toList();
  }


  Future<void> editName(int id, String Name) async{
    try{
      final db = await _database.database;
      await db.update(ProductTable.ProductTableName, {
        ProductTable.ProductName: Name,
      },
        where: 'Product_Id = ?',
        whereArgs: [
          id,
        ]
      );
    }catch(e){
      print('Error editing name: $e');
    }
  }

  Future<void> editCategory(int id, String Category) async{
    try{
      final db = await _database.database;
      await db.update(ProductTable.ProductTableName, {
        ProductTable.ProductCategory: Category,
      },
          where: 'Product_Id = ?',
          whereArgs: [
            id,
          ]
      );
    }catch(e){
      print('Error editing category: $e');
    }
  }

  Future<void> editPrice(int id, double Price) async{
    try{
      final db = await _database.database;
      await db.update(ProductTable.ProductTableName, {
        ProductTable.ProductPrice: Price,
      },
          where: 'Product_Id = ?',
          whereArgs: [
            id,
          ]
      );
    }catch(e){
      print('Error editing price: $e');
    }
  }

  Future<void> editImage(int id, String Filename) async {
    try {
      final db = await _database.database;
      await db.update(
        ProductTable.ProductTableName,
        {
          ProductTable.ProductImage: Filename,
        },
        where: 'Product_Id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error editing image: $e');
    }
  }

  Future<void> deleteProduct(int id) async{
    try{
      final db = await _database.database;
      await db.delete(ProductTable.ProductTableName,
      where: 'Product_Id = ?',
        whereArgs: [id],
      );
    }catch(e){
      print('Error deleting product: $e');
    }
  }

}