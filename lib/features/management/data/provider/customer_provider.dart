import 'package:coffee_pos/features/management/data/repository/customer_repository.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class CustomerNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final CustomerRepository _customerRepository;

  CustomerNotifier(this._customerRepository) : super(const AsyncValue.loading()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final orders = await _customerRepository.getOrders();
    state = AsyncValue.data(orders);

  }

  Future<void> updateCash(int orderId, double cash) async {
    await _customerRepository.updateCash(orderId, cash);
    await fetchOrders();
  }

  Future<void> updateChange(int orderId, double change) async{
    await _customerRepository.updateChange(orderId, change);
    await fetchOrders();
  }

  Future<void> deleteOrder(int orderId) async {
    await _customerRepository.deleteOrder(orderId);
    await fetchOrders();
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, AsyncValue<List<OrderModel>>>(
      (ref) {
    final repository = ref.read(customerRepositoryProvider);
    return CustomerNotifier(repository);
  },
);