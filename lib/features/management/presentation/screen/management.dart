import 'package:coffee_pos/core/widgets/container_tab.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/presentation/screen/customer_management.dart';
import 'package:coffee_pos/features/management/presentation/screen/orderlist_management.dart';
import 'package:coffee_pos/features/management/presentation/screen/product_management.dart';
import 'package:coffee_pos/features/management/presentation/widgets/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageScreen extends ConsumerStatefulWidget {
  const ManageScreen({super.key});

  @override
  ConsumerState<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends ConsumerState<ManageScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final manageTab = ref.watch(managementNotifierProvider);
    final selectedTab = ref.watch(selectedManageTabProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 52, 46),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Management',
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
                  builder: (context) => AddProduct(),
                );
              },
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: TextFormField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 0,
                    icon: Icons.fastfood,
                    name: 'Products',
                    isSelected: selectedTab == 0,
                  ),
                  const SizedBox(width: 10),
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 1,
                    icon: Icons.person,
                    name: 'Customer',
                    isSelected: selectedTab == 1,
                    badge: manageTab.asData?.value.orderLists.any((o) => o.TotalAmount > o.AmountGiven) == true ? '!' : null,
                  ),
                  const SizedBox(width: 10),
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 2,
                    icon: Icons.shopping_cart,
                    name: 'Customer Order',
                    isSelected: selectedTab == 2,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: manageTab.when(
                  data: (data) {
                    if (selectedTab == 0) {
                      final filteredProducts = data.products
                          .where((p) => p.name.toLowerCase().contains(searchQuery))
                          .toList();
                      return buildProductsTable(context, ref, filteredProducts, screenSize);
                    } else if (selectedTab == 1) {
                      final filteredOrders = data.orders
                          .where((o) => o.name.toLowerCase().contains(searchQuery))
                          .toList();
                      return buildCustomerTable(context, ref, filteredOrders, screenSize);
                    } else {
                      final filteredOrderLists = data.orderLists
                          .where((o) => o.CustomerName.toLowerCase().contains(searchQuery))
                          .toList();
                      return buildOrderListTable(context, ref, filteredOrderLists, screenSize);
                    }
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}




