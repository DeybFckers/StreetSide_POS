import 'package:coffee_pos/features/orderlist/data/models/orderlist_model.dart';
import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';


Widget buildOrderListTable(List<orderListModel> items, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('Customer',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Product',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Quantity',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Sub Total',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
    ],
    rows: items.map((o) {
      return DataRow(cells: [
        DataCell(Text(o.CustomerName,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.ProductName,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.Quantity.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.SubTotal.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
      ]);
    }).toList(),
  );
}