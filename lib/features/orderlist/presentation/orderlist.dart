import 'dart:io';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/orderlist_provider.dart';
import 'package:coffee_pos/features/orderlist/provider/ordertab_provider.dart';
import 'package:get/get.dart';
import 'package:coffee_pos/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderlistState = ref.watch(orderListNotifierProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 52, 46),
        title: Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pending Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: screenSize.height * 0.78,
                    width: screenSize.width * 0.35,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 245, 240),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: orderlistState.when(
                      data: (groupedOrders) {
                        final filteredOrders = Map.fromEntries(
                          groupedOrders.entries.map((entry) {
                            final inProgressItems = entry.value
                                .where((item) => item.OrderStatus == 'In Progress')
                                .toList();
                            return MapEntry(entry.key, inProgressItems);
                          }).where((entry) => entry.value.isNotEmpty),
                        );

                        if (filteredOrders.isEmpty) {
                          return Center(
                            child: Text(
                              'No Pending Orders',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                          );
                        }
                        final orderIds = filteredOrders.keys.toList();
                        return ListView.builder(
                          itemCount: orderIds.length,
                          itemBuilder: (context, index) {
                            final orderId = orderIds[index];
                            final items = filteredOrders[orderId]!;
                            final firstItem = items.first;
                            final isSelected = ref.watch(selectedOrderProvider) == orderId;
                            return GestureDetector(
                              onTap: () {
                                ref.read(selectedOrderProvider.notifier).state = orderId;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Card(
                                  color: isSelected
                                      ? Color.fromARGB(255, 78, 52, 46)
                                      : Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Order ID: #${firstItem.OrderId}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: isSelected ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Color.fromARGB(255, 78, 52, 46)
                                                    : firstItem.OrderType == 'Take Out'
                                                    ? Colors.orange.withOpacity(0.2)
                                                    : firstItem.OrderType == 'Delivery'
                                                    ? Colors.red.withOpacity(0.2)
                                                    : Colors.green.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                firstItem.OrderType,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : firstItem.OrderType == 'Take Out'
                                                      ? Colors.orange[800]
                                                      : firstItem.OrderType == 'Delivery'
                                                      ? Colors.red[800]
                                                      : Colors.green[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Customer: ${firstItem.CustomerName}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSelected ? Colors.white : Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '₱${firstItem.TotalAmount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (e, st) => Center(child: Text("Error: $e")),
                      loading: () => Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  SizedBox(width: 10),
                  Consumer(
                    builder: (context, ref, _) {
                      final selectedOrderId = ref.watch(selectedOrderProvider);
                      if (selectedOrderId == null) {
                        return SizedBox.shrink();
                      }
                      final selectedItems = orderlistState.asData?.value[selectedOrderId];
                      if (selectedItems == null || selectedItems.isEmpty) {
                        return SizedBox.shrink();
                      }
                      final firstItem = selectedItems.first;
                      return Expanded(
                        child: Container(
                          height: screenSize.height * 0.78,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 250, 245, 240),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text('Details',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18
                                                ),
                                              ),
                                            ),
                                            Text('${firstItem.OrderId}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Customer',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]
                                                  ),
                                                ),
                                                Text('${firstItem.CustomerName}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Payment',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]
                                                  ),
                                                ),
                                                Text('${firstItem.PaymentMethod}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Order Type',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]
                                                  ),
                                                ),
                                                Text('${firstItem.OrderType}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Discounted',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]
                                                  ),
                                                ),
                                                Text(firstItem.Discounted == 1 ? 'Yes' : 'No',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Total',
                                                  style: TextStyle(
                                                      color: Colors.grey[800]
                                                  ),
                                                ),
                                                Text('${firstItem.TotalAmount.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text('Orders',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: selectedItems.length,
                                              itemBuilder: (context, index) {
                                                final item = selectedItems[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(width: 1, color: Colors.grey),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Image.file(
                                                          File(item.ProductImage),
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text('${item.ProductName}  x${item.Quantity}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text('₱${item.SubTotal}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder: (context, index) => SizedBox(height: 10), // space between items
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (_){
                                                  return AlertDialog(
                                                    title: Text('${firstItem.CustomerName} Orders'),
                                                    content: Text('Are you sure you want to Refund this order?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: Text('Close'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try{
                                                            await ref.read(orderListNotifierProvider.notifier)
                                                                .updateOrderStatus(firstItem.OrderId!, 'Refund');

                                                            ref.read(selectedOrderProvider.notifier).state = null;
                                                            ref.read(managementNotifierProvider.notifier).fetchAll();
                                                            Get.snackbar(
                                                              "Success", "Order delete",
                                                              snackPosition: SnackPosition.BOTTOM,
                                                              backgroundColor: Colors.green,
                                                              colorText: Colors.white,
                                                            );
                                                            ref.read(managementNotifierProvider.notifier).fetchAll();
                                                            Navigator.pop(context);
                                                          }catch(e){
                                                            print('error updating $e');
                                                          }
                                                        },
                                                        child: Text('Confirm',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color.fromARGB(255, 121, 85, 72),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 18),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: Text(
                                            'Refund',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.red,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: CustomButton(
                                          text: 'Done',
                                          onPressed: () async {
                                            try{
                                              await ref.read(orderListNotifierProvider.notifier)
                                                  .updateOrderStatus(firstItem.OrderId!, 'Completed');

                                              ref.read(selectedOrderProvider.notifier).state = null;
                                              ref.read(managementNotifierProvider.notifier).fetchAll();
                                              Get.snackbar(
                                                "Success", "Order Complete",
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                              );
                                            }catch(e){
                                              print('error updating $e');
                                            }
                                          },
                                        )
                                      ),
                                    ],
                                  )
                                ]
                              ),
                            )
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

