import 'package:coffee_pos/features/products/data/repository/item_repository.dart';
import 'package:coffee_pos/features/products/data/repository/order_repository.dart';
import 'package:flutter/material.dart';

class TableCheck extends StatelessWidget {
  const TableCheck({super.key});

  @override
  Widget build(BuildContext context) {

    final orderRepository = OrderRepository();
    final itemRepository = ItemRepository();

    return IconButton(
      icon: Icon(Icons.table_chart),
      color: Colors.white,
      onPressed: () async {
        final orders = await orderRepository.getOrder();
        final items = await itemRepository.getItem();
        if (orders.isEmpty) {
          print("No orders yet.");
        } else {
          for (var order in orders) {
            print("Order ID: ${order.id}");
            print("Customer Name: ${order.name}");
            print("Total Amount: ${order.totalAmount}");
            print("Amount Given: ${order.amountGiven}");
            print("Change: ${order.change}");
            print("Order Type: ${order.orderType}");
            print("Payment Method: ${order.paymentMethod}");
            print("Status: ${order.orderStatus}");
            print("Created At: ${order.createdAt}");
            print("Discounted: ${order.discounted}");
            print("----------------------");
          }
        }

        if (items.isEmpty) {
          print("No items in table.");
        } else {
          for (var item in items) {
            print("Item ID: ${item.id}");
            print("Order ID: ${item.orderId}");
            print("Product ID: ${item.productId}");
            print("Quantity: ${item.quantity}");
            print("Subtotal: ${item.subTotal}");
            print("------------------------");
          }
        }
      },
    );
  }
}
