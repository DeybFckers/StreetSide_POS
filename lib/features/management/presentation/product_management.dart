import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:coffee_pos/features/products/data/models/product_model.dart';

Widget buildProductsTable(List<ProductModel> products, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('ID',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Name',
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
      DataColumn(label: Text('Price',
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
        DataCell(Text(p.id.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(p.name,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(p.category,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(p.price.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
      ]);
    }).toList(),
  );
}