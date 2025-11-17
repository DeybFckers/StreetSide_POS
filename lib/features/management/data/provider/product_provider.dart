// Import your data model and repository
import 'package:coffee_pos/features/management/data/models/product_model.dart';
import 'package:coffee_pos/features/management/data/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // optional, may not be needed depending on setup

// -----------------------------------------------------------------------------
// 🧩 StateNotifier: A Riverpod class that manages state changes for one feature.
// Here, ProductNotifier handles the state for a list of ProductModel objects.
// -----------------------------------------------------------------------------
class ProductNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  // The repository is the data source (database, API, etc.)
  final ProductRepository _productRepository;

  // Constructor - starts with loading state and fetches products immediately.
  ProductNotifier(this._productRepository) : super(const AsyncValue.loading()) {
    fetchProducts(); // Automatically fetch products when the notifier is created.
  }

  // -----------------------------------------------------------------------------
  // 📦 fetchProducts(): Reads all products from the database/repository.
  // Uses try-catch to handle both success and error states.
  // -----------------------------------------------------------------------------
  Future<void> fetchProducts() async {
    try {
      // Fetch data from repository (e.g., SQLite query)
      final products = await _productRepository.getProduct();

      // If successful, update the state with the new list of products
      state = AsyncValue.data(products);
    } catch (e, st) {
      // If an error occurs, store the error and stack trace for debugging
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<ProductModel>> fetchProductByCategory(String category) async {
    try {
      final categoryProduct = await _productRepository.getProductsByCategory(category);

      // update state
      state = AsyncValue.data(categoryProduct);

      // return result to UI
      return categoryProduct;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return []; // return empty list to avoid UI errors
    }
  }


  // -----------------------------------------------------------------------------
  // ➕ addProduct(): Adds a product to the repository, then refreshes the list.
  // -----------------------------------------------------------------------------
  Future<void> addProduct(ProductModel product) async {
    // Insert the product into the database
    await _productRepository.addProduct(product);

    // Re-fetch all products to reflect the new addition in the UI
    await fetchProducts();
  }

  Future<void> editName(int id, String newName) async {
    await _productRepository.editName(id, newName);
    await fetchProducts();
  }

  Future<void> editCategory(int id, String newCategory) async {
    await _productRepository.editCategory(id, newCategory);
    await fetchProducts();
  }

  Future<void> editPrice(int id, double newPrice) async {
    await _productRepository.editPrice(id, newPrice);
    await fetchProducts();
  }

  Future<void> editImage(int id, String fileName) async{
    await _productRepository.editImage(id, fileName);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async{
    await _productRepository.deleteProduct(id);
    await fetchProducts();
  }
}

// -----------------------------------------------------------------------------
// 🧱 Provider Definitions
// These tell Riverpod *how* to create and manage your data classes.
// -----------------------------------------------------------------------------

// Repository Provider: Provides an instance of ProductRepository (data layer)
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(); // Creates a single shared repository instance
});

// StateNotifier Provider: Connects your Notifier (logic) to the UI
// The state here is AsyncValue<List<ProductModel>>, which can be:
// - AsyncLoading
// - AsyncData
// - AsyncError
final productNotifierProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<ProductModel>>>((ref) {
  // Read the repository instance from above
  final repository = ref.read(productRepositoryProvider);

  // Create and return the notifier, passing the repository
  return ProductNotifier(repository);
});
