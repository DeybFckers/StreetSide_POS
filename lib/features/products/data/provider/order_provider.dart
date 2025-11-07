import 'package:coffee_pos/features/products/data/models/item_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/products/data/repository/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderRepository _orderRepository;

  OrderNotifier(this._orderRepository) : super(const AsyncValue.data([]));

  // OrderNotifier(this._orderRepository) : super(const AsyncValue.loading()){
  //   fetchOrder();
  // }
  Future<void>addOrder(OrderModel order, List<ItemModel> items) async{
    await _orderRepository.addOrder(order, items);

  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final orderNotifierProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<OrderModel>>>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return OrderNotifier(repository);
});