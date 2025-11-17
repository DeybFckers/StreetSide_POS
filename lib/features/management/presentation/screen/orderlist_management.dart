import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/core/widgets/edit_dialog.dart';
import 'package:coffee_pos/features/management/data/provider/customer_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/product_provider.dart';
import 'package:coffee_pos/features/management/utils/validator/order_validator.dart';
import 'package:coffee_pos/features/management/utils/validator/product_validator.dart';
import 'package:coffee_pos/features/management/data/models/orderlist_model.dart';
import 'package:coffee_pos/features/management/data/provider/orderlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

Widget buildOrderListTable(BuildContext context, WidgetRef ref, List<orderListModel> items, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('Customer',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Product',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Quantity',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Sub Total',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Actions',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
    ],
    rows: items.map((o) {
      return DataRow(cells: [
        DataCell(Text(o.CustomerName,
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.ProductName,
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.Quantity.toString(),
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.SubTotal.toString(),
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () async {
                final category = await showDropDownDialog(
                  context,
                  title: 'Select Product Category',
                  label: 'Category',
                  initialValue: 'Coffee',
                  items: ['Coffee', 'Drinks', 'Food'],
                  validator: ProductValidator.productCategory,
                );
                if (category == null) return;

                final products = await ref.read(productNotifierProvider.notifier).fetchProductByCategory(category);

                final selectedProduct = await showProductListDialog(
                  context,
                  title: 'Select New Product',
                  products: products,
                );
                if (selectedProduct == null) return;

                final quantityController = TextEditingController();
                showEditDialog(
                  context,
                  title: 'Enter Quantity',
                  label: 'Quantity',
                  controller: quantityController,
                  validator: OrderValidator.productQuantity,
                  keyboardType: TextInputType.number,
                  onConfirm: () async {
                    final newQuantity = int.tryParse(quantityController.text) ?? 0;
                    final newSubtotal = newQuantity * selectedProduct.price;

                    final orderNotifier = ref.read(orderListNotifierProvider.notifier);

                    await orderNotifier.updateOrderProduct(o.ItemId!, selectedProduct.id);
                    await orderNotifier.updateOrderQuantity(o.ItemId!, newQuantity);
                    await orderNotifier.updateOrderSubtotal(o.ItemId!, newSubtotal);

                    final currentState = ref.read(orderListNotifierProvider).asData?.value;
                    if (currentState != null && o.OrderId != null) {
                      final orderItems = currentState[o.OrderId!]!;
                      double newTotal = orderItems.fold<double>(0, (sum, item) => sum + item.SubTotal);
                      final isDiscounted = orderItems.first.Discounted == 1;
                      if (isDiscounted) newTotal *= 0.8;

                      await orderNotifier.updateOrderTotal(o.OrderId!, newTotal);

                      if (orderItems.first.PaymentMethod == 'Gcash') {
                        final customerNotifier = ref.read(customerNotifierProvider.notifier);
                        await customerNotifier.updateCash(o.OrderId!, newTotal);
                      }
                    }

                    ref.read(managementNotifierProvider.notifier).fetchAll();

                    if(context.mounted){
                      Get.snackbar(
                        "Success",
                        "Product Updated!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  },
                );
              },
              icon: Icon(Icons.edit, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.brown.withOpacity(0.85),
                    title: Text('Delete Order'),
                    content: Text('Are you sure you want to Delete?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Colors.red)),
                      ),
                      EditButton(
                        text: 'Confirm',
                        onPressed: () async {
                          Navigator.pop(context);

                          final orderListNotifier = ref.read(orderListNotifierProvider.notifier);
                          final customerNotifier = ref.read(customerNotifierProvider.notifier);

                          final currentState = ref.read(orderListNotifierProvider).asData?.value;

                          if (currentState != null && o.OrderId != null) {
                            await orderListNotifier.deleteOrder(o.ItemId!);

                            final updatedState = ref.read(orderListNotifierProvider).asData?.value;
                            final orderItems = updatedState?[o.OrderId!];

                            double newTotal = orderItems?.fold<double>(0, (sum, item) => sum + item.SubTotal) ?? 0;
                            final isDiscounted = orderItems?.first.Discounted == 1;
                            if (isDiscounted) newTotal *= 0.8;

                            await orderListNotifier.updateOrderTotal(o.OrderId!, newTotal);

                            final amountGiven = orderItems?.first.AmountGiven ?? 0;
                            final newChange = amountGiven - newTotal;
                            await customerNotifier.updateChange(o.OrderId!, newChange);

                            if (orderItems?.first.PaymentMethod == 'Gcash') {
                              final customerNotifier = ref.read(customerNotifierProvider.notifier);
                              await customerNotifier.updateCash(o.OrderId!, newTotal);
                            } else {
                              final amountGiven = orderItems?.first.AmountGiven ?? 0;
                              final newChange = amountGiven - newTotal;
                              await customerNotifier.updateChange(o.OrderId!, newChange);
                            }
                          }

                          ref.read(managementNotifierProvider.notifier).fetchAll();

                          if(context.mounted){
                            Get.snackbar(
                              "Success",
                              "Product Deleted, Total and Change Updated!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        )
        )
      ]);
    }).toList(),
  );
}