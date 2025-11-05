import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_notifier.g.dart';

class CartNotifier extends Notifier<Map<Product, int>> {
  @override
  Map<Product, int> build() => {};

  void addProduct(Product product) {
    state = {
      ...state,
      product: (state[product] ?? 0) + 1,
    };
  }

  void removeProduct(Product product) {
    final newState = Map<Product, int>.from(state);
    newState.remove(product);
    state = newState;
  }

  void addQuantity(Product product) {
    if (state.containsKey(product)) {
      state = {
        ...state,
        product: state[product]! + 1,
      };
    }
  }

  void subtractQuantity(Product product) {
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

final cartNotifierProvider = NotifierProvider<CartNotifier, Map<Product, int>>(() {
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
