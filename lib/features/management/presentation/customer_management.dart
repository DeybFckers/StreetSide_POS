import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:intl/intl.dart';


Widget buildCustomerTable(List<OrderModel> orders, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('Order ID',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Customer',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Payment Method',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Order Type',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Total Amount',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Change',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Status',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
      DataColumn(label: Text('Date',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15
          )
        )
      ),
    ],
    rows: orders.map((o) {
      return DataRow(cells: [
        DataCell(Text(o.id.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.name,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.paymentMethod,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.orderType,
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.totalAmount.toString(),
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(Text(o.change.toString()
          )
        ),
        DataCell(Text(o.orderStatus ?? '',
          style: TextStyle(fontSize: 15),
          )
        ),
        DataCell(
          Text(
            DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.parse(o.createdAt)),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ]);
    }).toList(),
  );
}