import 'package:coffee_pos/features/orderlist/data/models/orderlist_model.dart';
import 'package:coffee_pos/features/orderlist/data/repository/orderlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderlistNotifier extends StateNotifier<AsyncValue<Map<int, List<orderListModel>>>> {
  final OrderlistRepository _orderListRepository;

  OrderlistNotifier(this._orderListRepository) : super(AsyncValue.loading()) {
    fetchOrderList();
  }

  Future<void> fetchOrderList() async {
    try {
      final groupedOrders = await _orderListRepository.getGroupedOrders();
      state = AsyncValue.data(groupedOrders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      // 1. Update in DB
      await _orderListRepository.updateOrderStatus(orderId, status);

      // 2. Update locally in state
      state = state.whenData((groupedOrders) {
        final updated = Map<int, List<orderListModel>>.from(groupedOrders);
        final orderItems = updated[orderId];
        if (orderItems != null) {
          for (var item in orderItems) {
            item.OrderStatus = status;
          }
        }
        return updated;
      });
    } catch (e) {
      print('Error updating status in provider: $e');
    }
  }
}

final orderListRepositoryProvider = Provider<OrderlistRepository>((ref) {
  return OrderlistRepository();
});

final orderListNotifierProvider = StateNotifierProvider<
    OrderlistNotifier, AsyncValue<Map<int, List<orderListModel>>>>(
      (ref) {
    final repository = ref.read(orderListRepositoryProvider);
    return OrderlistNotifier(repository);
  },
);
