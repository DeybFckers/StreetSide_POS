import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_notifier.g.dart';

class CartNotifier extends Notifier<Map<ProductModel, int>> {
  @override
  Map<ProductModel, int> build() => {};

  void addProduct(ProductModel product) {
    state = {
      ...state,
      product: (state[product] ?? 0) + 1,
    };
  }

  void removeProduct(ProductModel product) {
    final newState = Map<ProductModel, int>.from(state);
    newState.remove(product);
    state = newState;
  }

  void addQuantity(ProductModel product) {
    if (state.containsKey(product)) {
      state = {
        ...state,
        product: state[product]! + 1,
      };
    }
  }

  void subtractQuantity(ProductModel product) {
    if (state.containsKey(product) && state[product]! > 1) {
      state = {
        ...state,
        product: state[product]! - 1,
      };
    }
  }

  void clearCart(){
    state = {};
  }
}

final cartNotifierProvider = NotifierProvider<CartNotifier, Map<ProductModel, int>>(() {
  return CartNotifier();
});

@riverpod
double cartTotal(ref){
  final cartProducts = ref.watch(cartNotifierProvider);

  double total = 0;

  cartProducts.forEach((product, quantity) {
    total += product.price * quantity;
  });

  return total;
}
