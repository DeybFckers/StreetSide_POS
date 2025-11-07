import 'dart:io';
import 'package:coffee_pos/features/products/data/models/item_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/products/data/provider/cart_notifier.dart';
import 'package:coffee_pos/features/products/data/provider/order_provider.dart';
import 'package:coffee_pos/features/products/data/provider/product_provider.dart';
import 'package:coffee_pos/features/products/data/repository/item_repository.dart';
import 'package:coffee_pos/features/products/data/repository/order_repository.dart';
import 'package:coffee_pos/features/products/presentation/add_product.dart';
import 'package:coffee_pos/core/widgets/container_tab.dart';
import 'package:coffee_pos/core/widgets/custom_button.dart';
import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/features/products/data/provider/tab_provider.dart';
import 'package:coffee_pos/features/products/utils/validator/checkout_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';


class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenSize = MediaQuery.of(context).size;
    final productState = ref.watch(productNotifierProvider);
    final cartProducts = ref.watch(cartNotifierProvider);
    final selectedIndex = ref.watch(selectedTabProvider);
    final filteredProducts = productState.when(
      data: (products){
        return products.where((product){
          if (selectedIndex == 0) return product.category == 'Coffee';
          if (selectedIndex == 1) return product.category == 'Food';
          if (selectedIndex == 2) return product.category == 'Drinks';
          return true;
        }).toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );
    final orderRepository = OrderRepository();
    final itemRepository = ItemRepository();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 52, 46),
        title: Row(
          children: [
            Expanded(
              child: Text('Products',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AddProduct();
                  }
                );
              },
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerTab(
                                onTap: () => ref.read(selectedTabProvider.notifier).state = 0,
                                icon: Icons.coffee_rounded,
                                name: 'Coffee',
                                isSelected: selectedIndex == 0,
                            ),
                            SizedBox(width: 10),
                            ContainerTab(
                                onTap: () => ref.read(selectedTabProvider.notifier).state = 1,
                                icon: Icons.fastfood,
                                name: 'Food',
                                isSelected: selectedIndex == 1,
                            ),
                            SizedBox(width: 10),
                            ContainerTab(
                                onTap: () => ref.read(selectedTabProvider.notifier).state = 2,
                                icon: Icons.local_drink,
                                name: 'Drinks',
                                isSelected: selectedIndex == 2,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: screenSize.height * 0.78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              itemCount: filteredProducts.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder:(context, index){
                                final product = filteredProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(top:8, left: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      ref.read(cartNotifierProvider.notifier).addProduct(filteredProducts[index]);
                                    },
                                    child: Card(
                                      color: Color.fromARGB(255, 245, 237, 224),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                              child: Image.file(
                                                  File(product.imageUrl),
                                                  width: 60, height: 60
                                              ),
                                            ),
                                            Text(product.name),
                                            Text('₱${product.price}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async{
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
                              print("Created At: ${order.createdAt}");
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
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.shopping_cart),
                              SizedBox(width: 10),
                              Text(
                                'Cart',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Container(
                          width: screenSize.width * 0.3,
                          height: screenSize.height * 0.78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Consumer(
                            builder: (context, ref, _) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: cartProducts.isEmpty
                                        ? Center(
                                      child: Text('Your cart is empty'),
                                    )
                                        : ListView.builder(
                                      itemCount: cartProducts.length,
                                      itemBuilder: (context, index){
                                        final product = cartProducts.keys.elementAt(index);
                                        final quantity = cartProducts[product]!;
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      leading: Image.file(
                                                        File(product.imageUrl),
                                                        width: 70,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      title: Text(product.name),
                                                      subtitle: Text('₱${product.price}'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 245, 237, 224),
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: Colors.brown),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(Icons.remove),
                                                          onPressed: () {
                                                            ref.read(cartNotifierProvider.notifier).subtractQuantity(product);
                                                          },
                                                        ),
                                                        Text('$quantity',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            ref.read(cartNotifierProvider.notifier).addQuantity(product);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    color: Colors.red,
                                                    onPressed: (){
                                                      ref.read(cartNotifierProvider.notifier).removeProduct(product);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Divider(thickness: 1.5),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                  ),
                                  if (cartProducts.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
                                      child: CustomButton(
                                        text: 'Checkout',
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              final total = ref.read(cartTotalProvider);
                                              final nameController = TextEditingController();
                                              final cashController = TextEditingController();
                                              final formKey = GlobalKey<FormState>();
                                              double change = 0.0;
                                              return AlertDialog(
                                                backgroundColor: Colors.brown.withOpacity(0.85),
                                                title: Text('Checkout Summary',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: StatefulBuilder(
                                                  builder: (context, setState) => Form(
                                                    key: formKey,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          controller: nameController,
                                                          decoration: customInputDecoration(
                                                            'Customer Name',
                                                            Icons.person
                                                          ),
                                                          validator: CheckoutValidator.customerName,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text('Total: ₱${total.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        TextFormField(
                                                          controller: cashController,
                                                          keyboardType: TextInputType.number,
                                                          decoration: customInputDecoration(
                                                            'Amount Given',
                                                            Icons.attach_money
                                                          ),
                                                          validator: CheckoutValidator.amountGiven,
                                                          onChanged: (val) {
                                                            final cash = double.tryParse(val) ?? 0;
                                                            setState(() => change = cash - total);
                                                          },
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text('Change: ₱${change.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('Cancel',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if(formKey.currentState!.validate()){
                                                        final cashGiven =  double.tryParse(cashController.text) ?? 0.0;

                                                        if(cashGiven < total){
                                                          Get.snackbar(
                                                            "Error", "Insufficient Funds",
                                                            snackPosition: SnackPosition.BOTTOM,
                                                            backgroundColor: Colors.red,
                                                            colorText: Colors.white,
                                                          );
                                                          return;
                                                        }

                                                        final items = cartProducts.entries.map((entry) => ItemModel(
                                                          productId: entry.key.id,
                                                          quantity: entry.value,
                                                          subTotal: entry.key.price * entry.value,
                                                        )).toList();

                                                        final order = OrderModel(
                                                            name: nameController.text,
                                                            totalAmount: total,
                                                            amountGiven: double.tryParse(cashController.text) ?? 0.0,
                                                            change: change,
                                                            createdAt: DateTime.now().toIso8601String()
                                                        );

                                                        final orderRepository = ref.read(orderRepositoryProvider);
                                                        await orderRepository.addOrder(order, items);
                                                        ref.read(cartNotifierProvider.notifier).clearCart();

                                                        Get.snackbar(
                                                          "Success", "Order Complete",
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                        );

                                                        Navigator.pop(context);
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
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              );
                            }
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
