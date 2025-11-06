import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:coffee_pos/features/products/data/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<ProductModel>>>{
  final ProductRepository _repository;

  ProductNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await _repository.getProduct();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _repository.addProduct(product);
    await fetchProducts(); // refresh list
  }

}



final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<ProductModel>>>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return ProductNotifier(repository);
});