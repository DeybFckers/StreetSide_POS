
class ProductModel {
  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map){
    return ProductModel(
      id: map['Product_Id'] as int,
      name: map['Product_Name'] as String,
      category: map['Product_Category'] as String,
      price: (map['Product_Price'] as num).toDouble(),
      imageUrl: map['Product_Image'] as String,
    );
  }
}