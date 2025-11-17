import 'dart:io';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/orderlist_provider.dart';
import 'package:coffee_pos/features/orderlist/presentation/orderlist.dart';
import 'package:coffee_pos/features/products/data/models/item_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/products/data/provider/cart_notifier.dart';
import 'package:coffee_pos/features/management/data/provider/product_provider.dart';
import 'package:coffee_pos/features/products/data/repository/order_repository.dart';
import 'package:coffee_pos/core/widgets/container_tab.dart';
import 'package:coffee_pos/core/widgets/custom_button.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/features/products/data/provider/tab_provider.dart';
import 'package:coffee_pos/features/products/utils/validator/checkout_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final nameController = TextEditingController();
  final cashController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final productState = ref.watch(productNotifierProvider);
    final cartProducts = ref.watch(cartNotifierProvider);
    final selectedIndex = ref.watch(selectedTabProvider);
    final selectedPaymentMethod = ref.watch(selectedMethodProvider);
    final selectedOrderType = ref.watch(selectedTypeProvider);

    final total = ref.watch(cartTotalProvider);
    final isDiscounted = ref.watch(isDiscountedProvider);
    final change = ref.watch(changeProvider);

    final filteredProducts = productState.when(
      data: (products) {
        return products.where((product) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 52, 46),
        title: Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: GridView.builder(
                            itemCount: filteredProducts.length,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (screenSize.width ~/ 180).clamp(2, 6),
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8, left: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(cartNotifierProvider.notifier).addProduct(product);
                                  },
                                  child: Card(
                                    color: Color.fromARGB(255, 245, 237, 224),
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12), bottom: Radius.circular(12)),
                                            child: Image.file(
                                              File(product.imageUrl),
                                              width: 150,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            product.name,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          Text(
                                            '₱${product.price}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListScreen()),
                          );
                        },
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
                      SizedBox(height: 15),
                      Container(
                        width: screenSize.width * 0.3,
                        height: screenSize.height * 0.78,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: cartProducts.isEmpty
                                  ? Center(child: Text('Your cart is empty'))
                                  : Column(
                                children: [
                                  Form(
                                    key: formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText: 'Customer Name',
                                                contentPadding:
                                                EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                                              ),
                                              validator: CheckoutValidator.customerName,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          ContainerTab(
                                            onTap: () => ref.read(selectedTypeProvider.notifier).state = 'Dine In',
                                            icon: Icons.local_dining,
                                            name: 'Dine In',
                                            isSelected: selectedOrderType == 'Dine In',
                                          ),
                                          SizedBox(width: 5),
                                          ContainerTab(
                                            onTap: () => ref.read(selectedTypeProvider.notifier).state = 'Take Out',
                                            icon: Icons.fastfood,
                                            name: 'Take Out',
                                            isSelected: selectedOrderType == 'Take Out',
                                          ),
                                          SizedBox(width: 5),
                                          ContainerTab(
                                            onTap: () => ref.read(selectedTypeProvider.notifier).state = 'Delivery',
                                            icon: Icons.delivery_dining,
                                            name: 'Delivery',
                                            isSelected: selectedOrderType == 'Delivery',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cartProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = cartProducts.keys.elementAt(index);
                                        final quantity = cartProducts[product]!;
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.file(
                                                    File(product.imageUrl),
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(product.name,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold, fontSize: 14)),
                                                        Text('₱${product.price}',
                                                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                                                        Text(
                                                            'Subtotal: ₱${(product.price * quantity).toStringAsFixed(2)}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.brown,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.remove),
                                                        onPressed: () {
                                                          ref
                                                              .read(cartNotifierProvider.notifier)
                                                              .subtractQuantity(product);
                                                        },
                                                      ),
                                                      Text('$quantity',
                                                          style: TextStyle(
                                                              fontSize: 18, fontWeight: FontWeight.bold)),
                                                      IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () {
                                                          ref
                                                              .read(cartNotifierProvider.notifier)
                                                              .addQuantity(product);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      ref.read(cartNotifierProvider.notifier).removeProduct(product);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Divider(thickness: 1.5),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: screenSize.height * 0.22,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 247, 247, 247),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ContainerTab(
                                                  onTap: () =>
                                                  ref.read(selectedMethodProvider.notifier).state = 'Cash',
                                                  icon: Icons.money,
                                                  name: 'Cash',
                                                  isSelected: selectedPaymentMethod == 'Cash',
                                                ),
                                                SizedBox(width: 8),
                                                ContainerTab(
                                                  onTap: () =>
                                                  ref.read(selectedMethodProvider.notifier).state = 'Gcash',
                                                  icon: Icons.credit_card,
                                                  name: 'Gcash',
                                                  isSelected: selectedPaymentMethod == 'Gcash',
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "PWD/Senior",
                                                        style: TextStyle(
                                                            fontSize: 14, fontWeight: FontWeight.w500),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Flexible(
                                                        child: CupertinoSwitch(
                                                          value: isDiscounted,
                                                          onChanged: (val) {
                                                            ref.read(isDiscountedProvider.notifier).state = val;
                                                            final discountedTotal = val ? total * 0.8 : total;
                                                            final cash = double.tryParse(cashController.text) ?? 0.0;
                                                            ref.read(changeProvider.notifier).state = cash - discountedTotal;
                                                          },
                                                          activeColor: Colors.brown,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (selectedPaymentMethod == 'Cash')
                                                  Expanded(
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                      controller: cashController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Amount',
                                                        hintText: '₱0.00',
                                                        labelStyle: TextStyle(fontSize: 13),
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8)),
                                                        contentPadding:
                                                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      ),
                                                      onChanged: (val) {
                                                        ref.read(cashGivenProvider.notifier).state = val;
                                                        final discountedTotal =
                                                        isDiscounted ? total * 0.8 : total;
                                                        final cash = double.tryParse(val) ?? 0.0;
                                                        ref.read(changeProvider.notifier).state = cash - discountedTotal;
                                                      },
                                                      validator: CheckoutValidator.amountGiven,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            if (isDiscounted)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Discount (20%):",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Text(
                                                    "-₱${(total * 0.2).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Total:",
                                                    style: TextStyle(
                                                        fontSize: 14, fontWeight: FontWeight.bold)),
                                                Text(
                                                  "₱${(isDiscounted ? total * 0.8 : total).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Change:",
                                                  style:
                                                  TextStyle(fontSize: 13, color: Colors.grey[800]),
                                                ),
                                                Text(
                                                  selectedPaymentMethod == 'Gcash'
                                                      ? "₱0.00"
                                                      : "₱${change.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: selectedPaymentMethod == 'Gcash'
                                                        ? Colors.grey[600]
                                                        : Colors.green[700],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (cartProducts.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
                                child: CustomButton(
                                  text: 'Checkout',
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      final discountedTotal = isDiscounted ? total * 0.8 : total; // Apply discount here
                                      final cashGiven = double.tryParse(cashController.text) ?? 0.0;

                                      if (selectedPaymentMethod == 'Cash' && cashGiven < discountedTotal) {
                                        Get.snackbar(
                                          "Error",
                                          "Insufficient Funds",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      if (selectedPaymentMethod == null) {
                                        Get.snackbar(
                                          "Error",
                                          "Please Select Payment Method",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      if (selectedOrderType == null) {
                                        Get.snackbar(
                                          "Error",
                                          "Please Select Order Type",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      // Prepare items for the order
                                      final items = cartProducts.entries.map((entry) => ItemModel(
                                        productId: entry.key.id,
                                        quantity: entry.value,
                                        subTotal: entry.key.price * entry.value,
                                      )).toList();

                                      final order = OrderModel(
                                        name: nameController.text,
                                        totalAmount: discountedTotal,
                                        amountGiven: selectedPaymentMethod == 'Cash' ? cashGiven : discountedTotal,
                                        change: selectedPaymentMethod == 'Cash' ? cashGiven - discountedTotal : 0.0,
                                        paymentMethod: selectedPaymentMethod ?? 'Cash',
                                        orderType: selectedOrderType ?? 'Dine In',
                                        discounted: isDiscounted ? 1 : 0,
                                        createdAt: DateTime.now().toIso8601String(),
                                      );


                                      final orderListNotifier = ref.read(orderListNotifierProvider.notifier);
                                      await orderRepository.addOrder(order, items);

                                      ref.read(cartNotifierProvider.notifier).clearCart();
                                      setState(() {});
                                      nameController.clear();
                                      cashController.clear();
                                      ref.read(selectedMethodProvider.notifier).state = null;
                                      ref.read(selectedTypeProvider.notifier).state = null;
                                      await orderListNotifier.fetchOrderList();
                                      ref.read(managementNotifierProvider.notifier).fetchAll();

                                      if(context.mounted){
                                        Get.snackbar(
                                          "Success",
                                          "Order added to list",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}