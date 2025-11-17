import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/product_provider.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';
import 'package:coffee_pos/features/management/utils/helper/file_helper.dart';
import 'package:coffee_pos/features/management/utils/validator/add_validator.dart';
import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final filenameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedCategory;
  PlatformFile? pickedFile;
  String? savedImagePath;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    filenameController.dispose();
    super.dispose();
  }

  Future<void> selectFile() async {
    final file = await FileHelper.pickFile();
    if (file != null) {
      final path = await FileHelper.saveFilePermanently(file);
      setState(() {
        pickedFile = file;
        savedImagePath = path;
        filenameController.text = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.brown.withOpacity(0.85),
      title: Text('Add Product'),
      content: SizedBox(
        width: screenSize.width * 0.35,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: customInputDecoration('Product Name', Icons.fastfood),
                validator: AddValidator.name,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration: customInputDecoration('Price', Icons.attach_money),
                keyboardType: TextInputType.number,
                validator: AddValidator.price,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: customInputDecoration('Category', Icons.category),
                dropdownColor: Colors.brown.withOpacity(0.85),
                items: ['Coffee', 'Drinks', 'Food']
                    .map(
                      (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: AddValidator.category,
              ),
             SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: filenameController,
                      readOnly: true,
                      decoration: customInputDecoration('File Name', Icons.file_present),
                      validator: AddValidator.filename,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: selectFile,
                    child:Text(
                      'Upload File',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 121, 85, 72),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final product = ProductModel(
                id: 0,
                name: nameController.text.trim(),
                category: selectedCategory!,
                price: double.parse(priceController.text),
                imageUrl: savedImagePath ?? '',
              );

              await ref.read(productNotifierProvider.notifier).addProduct(product);
              await ref.read(productNotifierProvider.notifier).fetchProducts();
              ref.read(managementNotifierProvider.notifier).fetchAll();

              Get.snackbar(
                "Success",
                "Product Added successfully",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

              Navigator.pop(context);
            }
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 121, 85, 72),
          ),
        ),
      ],
    );
  }
}
