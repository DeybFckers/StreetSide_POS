import 'package:coffee_pos/features/products/data/provider/product_provider.dart';
import 'package:coffee_pos/features/products/presentation/add_product.dart';
import 'package:coffee_pos/core/widgets/container_tab.dart';
import 'package:coffee_pos/core/widgets/custom_button.dart';
import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/features/products/data/provider/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/cart_notifier.dart';

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
                                              child: Image.asset(
                                                  product.imageUrl,
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
                      Row(
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
                                                      leading: Image.asset(
                                                        product.imageUrl,
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
                                              double change = 0.0;
                                              return AlertDialog(
                                                backgroundColor: Colors.brown.withOpacity(0.85),
                                                title: Text('Checkout Summary',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: StatefulBuilder(
                                                  builder: (context, setState) => Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller: nameController,
                                                        decoration: customInputDecoration(
                                                          'Customer Name',
                                                          Icons.person
                                                        )
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text('Total: ₱${total.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      TextField(
                                                        controller: cashController,
                                                        keyboardType: TextInputType.number,
                                                        decoration: customInputDecoration(
                                                          'Amount Given',
                                                          Icons.attach_money
                                                        ),
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
                                                    onPressed: () {
                                                      ref.read(cartNotifierProvider.notifier).clearCart();
                                                      Navigator.pop(context);
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
