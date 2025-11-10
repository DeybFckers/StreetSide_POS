import 'package:coffee_pos/core/widgets/container_tab.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/core/widgets/tablecheck.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/presentation/customer_management.dart';
import 'package:coffee_pos/features/management/presentation/order_management.dart';
import 'package:coffee_pos/features/management/presentation/product_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageScreen extends ConsumerWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
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
            TableCheck()
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 0,
                    icon: Icons.fastfood,
                    name: 'Products',
                    isSelected: selectedTab == 0,
                  ),
                  SizedBox(width: 10),
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 1,
                    icon: Icons.person,
                    name: 'Customer',
                    isSelected: selectedTab == 1,
                  ),
                  SizedBox(width: 10),
                  ContainerTab(
                    onTap: () => ref.read(selectedManageTabProvider.notifier).state = 2,
                    icon: Icons.shopping_cart,
                    name: 'Customer Order',
                    isSelected: selectedTab == 2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: manageTab.when(
                  data: (data) {
                    if (selectedTab == 0) {
                      return buildProductsTable(data.products, screenSize);
                    } else if (selectedTab == 1) {
                      return buildCustomerTable(data.orders, screenSize);
                    } else {
                      return buildOrderListTable(data.orderLists, screenSize);
                    }
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



