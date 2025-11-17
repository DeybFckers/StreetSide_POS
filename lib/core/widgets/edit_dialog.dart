import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';
import 'package:flutter/material.dart';

Future<void> showEditDialog(
    BuildContext context, {
      required String title,
      required String label,
      required TextEditingController controller,
      required String? Function(String?) validator,
      required VoidCallback onConfirm,
      TextInputType? keyboardType,
      IconData? icon,
    }) async {
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.brown.withOpacity(0.85),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            validator: validator,
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                onConfirm();
              }
            },
            decoration: customInputDecoration(
              label,
              icon,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          EditButton(
            text: 'Confirm',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                onConfirm();
              }
            },
          )
        ],
      );
    },
  );
}

Future<String?> showDropDownDialog(
    BuildContext context, {
      required String title,
      required String label,
      required String initialValue,
      required List<String> items,
      required String? Function(String?) validator,
    }) async {

  final formKey = GlobalKey<FormState>();
  String? selectedValue = initialValue;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.brown.withOpacity(0.85),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: DropdownButtonFormField<String>(
            value: initialValue,
            decoration: customInputDecoration(label, Icons.category),
            dropdownColor: Colors.brown.withOpacity(0.85),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
                .toList(),
            onChanged: (value) {
              selectedValue = value;
            },
            validator: validator,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          EditButton(
            text: 'Confirm',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, selectedValue);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showFileUploadDialog(
    BuildContext context, {
      required TextEditingController filenameController,
      required VoidCallback onFileSelected,
      required VoidCallback onConfirm,
      required String? Function(String?) validator,
      IconData? icon,
    }) async {
  final formKey = GlobalKey<FormState>();
  final screenSize = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.brown.withOpacity(0.85),
        title: const Text(
          'Upload File',
          style: TextStyle(color: Colors.white),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        content: SizedBox(
          width: screenSize.width * 0.35,
          child: Form(
            key: formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: filenameController,
                    readOnly: true,
                    decoration: customInputDecoration(
                        'File Name', icon ?? Icons.file_present),
                    validator: validator
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onFileSelected,
                  child: const Text(
                    'Select File',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 85, 72),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          EditButton(
            text: 'Confirm',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                onConfirm();
              }
            },
          ),
        ],
      );
    },
  );
}

Future<ProductModel?> showProductListDialog(
    BuildContext context, {
      required String title,
      required List<ProductModel> products,
      String? initialValue,
    }) async {
  final screenSize = MediaQuery.of(context).size;
  return showDialog<ProductModel>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.brown.withOpacity(0.85),
      title: Text(title, style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: screenSize.width * 0.35,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) {
            final p = products[i];
            return ListTile(
              title: Text(p.name, style: TextStyle(color: Colors.white)),
              trailing: Text("₱${p.price}", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, p),
            );
          },
        ),
      ),
    ),
  );
}






