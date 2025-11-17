import 'package:coffee_pos/features/management/data/models/orderlist_model.dart';
import 'package:coffee_pos/features/management/data/repository/orderlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderlistNotifier extends StateNotifier<AsyncValue<Map<int, List<orderListModel>>>> {
  final OrderlistRepository _orderListRepository;

  OrderlistNotifier(this._orderListRepository) : super(AsyncValue.loading()) {
    fetchOrderList();
  }

  Future<void> fetchOrderList() async {
    final groupedOrders = await _orderListRepository.getGroupedOrders();
    state = AsyncValue.data(groupedOrders);
  }

  Future<void> updateOrderProduct(int orderId, int productId) async {
    await _orderListRepository.updateOrderProduct(orderId, productId);
    await fetchOrderList();
  }

  Future<void> updateOrderQuantity(int orderId, int quantity) async{
    await _orderListRepository.updateOrderQuantity(orderId, quantity);
    await fetchOrderList();
  }

  Future<void> updateOrderSubtotal(int orderId, double subtotal) async{
    await _orderListRepository.updateOrderSubTotal(orderId, subtotal);
    await fetchOrderList();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {

      await _orderListRepository.updateOrderStatus(orderId, status);

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

  Future<void> updateOrderTotal(int orderId, double total) async{
    await _orderListRepository.updateTotal(orderId, total);
    await fetchOrderList();
  }

  Future<void> deleteOrder(int itemId) async{
    await _orderListRepository.deleteOrderItem(itemId);
    await fetchOrderList();
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
