import 'package:coffee_pos/features/products/presentation/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthService {
  static void login(String username, String password) {
    if (username == 'admin' && password == 'admin') {
      Get.snackbar("Success", "Login Successfully");
      Get.off(() => ProductScreen());
    } else {
      Get.snackbar(
        "Error",
        "Invalid credentials.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}