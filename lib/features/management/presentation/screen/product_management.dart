import 'dart:io';
import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/core/widgets/edit_dialog.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/data/provider/product_provider.dart';
import 'package:coffee_pos/features/management/utils/helper/file_helper.dart';
import 'package:coffee_pos/features/management/utils/validator/product_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

Widget buildProductsTable(BuildContext context, WidgetRef ref, List<ProductModel> products, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('Name',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
      DataColumn(label: Text('Price',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
      DataColumn(label: Text('Category',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
      DataColumn(label: Text('Image',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
      DataColumn(label: Text('Actions',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
      )
      ),
    ],
    rows: products.map((p) {
      return DataRow(cells: [
        DataCell(Text(p.name,
          style: TextStyle(fontSize: 12),
        )
        ),
        DataCell(Text(p.price.toString(),
          style: TextStyle(fontSize: 12),
        )
        ),
        DataCell(Text(p.category,
          style: TextStyle(fontSize: 12),
        )
        ),
        DataCell(Image.file(
          File(p.imageUrl),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
        ),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (_){
                    return AlertDialog(
                      backgroundColor: Colors.brown.withOpacity(0.85),
                      title: Text('Select a Column',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        EditButton(
                          text: 'Name',
                          onPressed: (){
                            Navigator.pop(context);
                            final nameController = TextEditingController();
                            //name Field
                            showEditDialog(
                              context,
                              title: "Edit Name",
                              label: "Product Name",
                              controller: nameController,
                              icon: Icons.fastfood,
                              validator: ProductValidator.productName,
                              onConfirm: () {
                                ref.read(productNotifierProvider.notifier).editName(p.id!, nameController.text);
                                ref.read(productNotifierProvider.notifier).fetchProducts();
                                ref.read(managementNotifierProvider.notifier).fetchAll();
                                Get.snackbar(
                                  "Success", "Product name updated!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                            );
                          }
                        ),
                        EditButton(
                          text: 'Price',
                          onPressed: (){
                            Navigator.pop(context);
                            //price field
                            final priceController = TextEditingController();
                            showEditDialog(
                              context,
                              title: "Edit Price",
                              label: "Product Price",
                              controller: priceController,
                              icon: Icons.fastfood,
                              validator: ProductValidator.productPrice,
                              keyboardType: TextInputType.number,
                              onConfirm: () {
                                final priceChange = double.tryParse(priceController.text) ?? 0.0;
                                ref.read(productNotifierProvider.notifier).editPrice(p.id!, priceChange);
                                ref.read(productNotifierProvider.notifier).fetchProducts();
                                ref.read(managementNotifierProvider.notifier).fetchAll();
                                Get.snackbar(
                                  "Success", "Product price updated!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                            );
                          }
                        ),
                        EditButton(
                          text: 'Category',
                          onPressed: () async{
                            //category field
                            Navigator.pop(context);
                            final selected = await showDropDownDialog(
                              context,
                              title: "Edit Category",
                              label: "Category",
                              initialValue: p.category,
                              items: ["Coffee", "Drinks", "Food"],
                              validator: ProductValidator.productCategory,
                            );

                            if (selected != null) {
                              ref.read(productNotifierProvider.notifier).editCategory(p.id!, selected);
                              ref.read(productNotifierProvider.notifier).fetchProducts();
                              ref.read(managementNotifierProvider.notifier).fetchAll();
                              Get.snackbar(
                                "Success", "Product category updated!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                          }
                        ),
                        EditButton(
                          text: 'Image',
                          onPressed: () async {
                            Navigator.pop(context);
                            final filenameController = TextEditingController();
                            PlatformFile? selectedFile;

                            await showFileUploadDialog(
                              context,
                              filenameController: filenameController,
                              validator: ProductValidator.productFilename, // ✅ now exists
                              onFileSelected: () async {
                                final file = await FileHelper.pickFile();
                                if (file != null) {
                                  filenameController.text = file.name;
                                  selectedFile = file;
                                }
                              },
                              onConfirm: () async {
                                if (selectedFile != null) {
                                  final path = await FileHelper.saveFilePermanently(selectedFile!);
                                  ref.read(productNotifierProvider.notifier).editImage(p.id!, path);
                                  ref.read(productNotifierProvider.notifier).fetchProducts();
                                  ref.read(managementNotifierProvider.notifier).fetchAll();
                                  Get.snackbar(
                                    "Success",
                                    "Product image updated!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            );
                          },
                        )
                      ],
                    );
                  }
                );
              },
              icon: Icon(Icons.edit,
                  color: Colors.green
              )
            ),
            IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.brown.withOpacity(0.85),
                    title: Text('Delete Product'),
                    content: Text('Are you sure you want to Delete?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ),
                      ),
                      EditButton(
                        text: 'Confirm',
                        onPressed: (){
                          Navigator.pop(context);
                          ref.read(productNotifierProvider.notifier).deleteProduct(p.id);
                          ref.read(productNotifierProvider.notifier).fetchProducts();
                          ref.read(managementNotifierProvider.notifier).fetchAll();
                          Get.snackbar(
                            "Success", "Record Delete Successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      )
                    ]
                  ),
                );
              },
              icon: Icon(Icons.delete,
                color: Colors.red,
              )
            )
          ],
        )
        )
      ]);
    }).toList(),
  );
}