import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_pos/features/management/data/repository/management_repository.dart';
import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/orderlist/data/models/orderlist_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class ManagementNotifier extends StateNotifier<
    AsyncValue<({
    List<ProductModel> products,
    List<OrderModel> orders,
    List<orderListModel> orderLists
    })>> {
  final ManagementRepository _repository;

  ManagementNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      final products = await _repository.getManagementProduct();
      final orders = await _repository.getManagementOrder();
      final orderLists = await _repository.getManagementOrderList();

      state = AsyncValue.data((
      products: products,
      orders: orders,
      orderLists: orderLists,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final managementRepositoryProvider = Provider((ref) => ManagementRepository());

final managementNotifierProvider = StateNotifierProvider<ManagementNotifier,
    AsyncValue<({
    List<ProductModel> products,
    List<OrderModel> orders,
    List<orderListModel> orderLists
    })>>((ref) {
  final repo = ref.read(managementRepositoryProvider);
  return ManagementNotifier(repo);
});

final selectedManageTabProvider = StateProvider<int>((ref) => 0);
