import 'package:coffee_pos/features/products/data/models/product_model.dart';
import 'package:coffee_pos/features/products/data/provider/product_provider.dart';
import 'package:coffee_pos/features/products/utils/validator/add_validator.dart';
import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


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

  Future<String> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return await File(file.path!).copy(newFile.path).then((f) => f.path);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;

    final file = result.files.first;
    final permanentPath = await saveFilePermanently(file);

    setState(() {
      pickedFile = file;
      savedImagePath = permanentPath;
      filenameController.text = file.name;
    });
  }

  @override
  void dispose(){
    nameController.dispose();
    priceController.dispose();
    filenameController.dispose();
    super.dispose();
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
            mainAxisSize:  MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: customInputDecoration(
                    'Product Name',
                    Icons.fastfood
                ),
                validator: AddValidator.name,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration: customInputDecoration(
                    'Price',
                    Icons.attach_money
                ),
                keyboardType:  TextInputType.number,
                validator: AddValidator.price,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: customInputDecoration(
                    'Category',
                    Icons.category
                ),
                dropdownColor: Colors.brown.withOpacity(0.85),
                items: [
                  'Coffee',
                  'Drinks',
                  'Food',
                ].map((location) => DropdownMenuItem(
                  value: location,
                  child: Text(location),
                )).toList(),
                onChanged: (value){
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
                      decoration: customInputDecoration(
                          'File Name',
                          Icons.file_present
                      ),
                      validator: AddValidator.filename,
                    )
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: (){
                      selectFile();
                    },
                    child: Text('Upload File',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 121, 85, 72),
                    ),
                  )
                ],
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
          onPressed: () async{
            if(formKey.currentState!.validate()){
              final product = ProductModel(
                id: 0,
                name: nameController.text.trim(),
                category: selectedCategory!,
                price: double.parse(priceController.text),
                imageUrl: savedImagePath ?? '',
              );

              await ref.read(productNotifierProvider.notifier).addProduct(product);

              Get.snackbar(
                "Success", "Product Added successfully",
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
  }
}
