import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/core/widgets/edit_dialog.dart';
import 'package:coffee_pos/features/management/data/provider/customer_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/orderlist_provider.dart';
import 'package:coffee_pos/features/management/utils/validator/customer_validator.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

Widget buildCustomerTable(BuildContext context, WidgetRef ref, List<OrderModel> orders, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('ID',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Customer',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Payment',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Type',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Discounted',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
      DataColumn(label: Text('Total',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Cash',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Change',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Status',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Date',
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
    rows: orders.map((o) {
      return DataRow(cells: [
        DataCell(Text(o.id.toString(),
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.name,
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.paymentMethod,
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.orderType,
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.discounted == 1 ? 'Yes' : 'No',
          style: TextStyle(fontSize: 12),
        )
        ),
        DataCell(
          Row(
            children: [
              Text(
                o.totalAmount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 12,
                  color: o.totalAmount > o.amountGiven ? Colors.red : Colors.black,
                  fontWeight: o.totalAmount > o.amountGiven ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (o.totalAmount > o.amountGiven) ...[
                SizedBox(width: 2),
                Icon(Icons.warning, color: Colors.red, size: 16),
              ],
            ],
          ),
        ),
        DataCell(Text(o.amountGiven.toStringAsFixed(2),
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.change.toStringAsFixed(2),
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(Text(o.orderStatus ?? '',
          style: TextStyle(fontSize: 12),
          )
        ),
        DataCell(
          Text(
            DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.parse(o.createdAt)),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {
                final cashController = TextEditingController();
                showEditDialog(
                  context,
                  title: 'Enter Cash',
                  label: 'Cash',
                  controller: cashController,
                  validator: CustomerValidator.amountGiven,
                  keyboardType: TextInputType.number,
                  onConfirm: () async {
                    final newCash = double.tryParse(cashController.text) ?? 0;
                    final newChange = newCash - o.totalAmount;

                    if(newCash < o.totalAmount){
                      Get.snackbar(
                        "Error", "Insufficient Funds",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    ref.read(customerNotifierProvider.notifier).updateChange(o.id!, newChange);
                    ref.read(customerNotifierProvider.notifier).updateCash(o.id!, newCash);
                    ref.read(managementNotifierProvider.notifier).fetchAll();

                    Get.snackbar(
                      "Success", "Amount Updated!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                );
              },
              icon: Icon(Icons.edit, color: Colors.green),
            ),
            IconButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.brown.withOpacity(0.85),
                        title: Text('Delete Order'),
                        content: Text('Are you sure you want to Delete?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                              style: TextStyle(
                                  color: Colors.red
                              ),
                            ),
                          ),
                          EditButton(
                            text: 'Confirm',
                            onPressed: (){
                              Navigator.pop(context);
                              ref.read(customerNotifierProvider.notifier).deleteOrder(o.id!);
                              ref.read(orderListNotifierProvider.notifier).fetchOrderList();
                              ref.read(managementNotifierProvider.notifier).fetchAll();
                              Get.snackbar(
                                "Success", "Product Updated!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                          )
                        ],
                      )
                  );
                },
              icon: Icon(Icons.delete,
                color: Colors.red,
              )
            )
          ],
        )
        )
      ]);
    }).toList(),
  );
}