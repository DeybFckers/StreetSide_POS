import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<Product> allProducts = [

  Product(id: '1', name: 'Choco', price: 49.0, imageUrl: 'assets/products/Choco.png', category: 'Drinks'),
  Product(id: '2', name: 'Coffee', price: 49.0, imageUrl: 'assets/products/Coffee.png', category: 'Coffee'),
  Product(id: '3', name: 'Matcha', price: 49.0, imageUrl: 'assets/products/Matcha.png', category: 'Food'),

];

final productList =  Provider((ref){
  return allProducts;
});