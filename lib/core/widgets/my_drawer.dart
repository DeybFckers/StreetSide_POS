import 'package:coffee_pos/features/products/presentation/products.dart';
import 'package:coffee_pos/features/auth/presentation/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DrawerControllerX extends GetxController{
  var selectedIndex = 0.obs;

  void selectIndex(int index) {
    selectedIndex.value = index;
  }
}

Future<void> logout() async {
  Get.offAll(() => LoginScreen());
}


class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final DrawerControllerX drawerController = Get.put(DrawerControllerX());

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.coffee, "title": "Products", "page": () => ProductScreen()},
    {"icon": Icons.logout, "title": "Logout", "page": () => LoginScreen()},

  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 245, 237, 224),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 78, 52, 46),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Image.asset(
                      "assets/images/StreetSide_BG.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Obx(() {
                  bool isSelected = drawerController.selectedIndex.value == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 109, 76, 65).withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item["icon"],
                        color: isSelected
                            ? Color.fromARGB(255, 78, 52, 46)
                            :  Color.fromARGB(255, 109, 76, 65),
                      ),
                      title: Text(
                        item["title"],
                        style: TextStyle(
                          color: isSelected
                              ? Color.fromARGB(255, 78, 52, 46)
                              : Color.fromARGB(255, 109, 76, 65),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        if (item["title"] == "Logout") {
                          logout();
                        } else {
                          drawerController.selectIndex(index);
                          Get.to(item["page"]());
                        }
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
