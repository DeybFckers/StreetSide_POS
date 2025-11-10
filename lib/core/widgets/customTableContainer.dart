import 'package:flutter/material.dart';

class CustomTableContainer extends StatelessWidget {
  final double height;
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const CustomTableContainer({
    Key? key,
    required this.height,
    required this.columns,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Color.fromARGB(255, 121, 85, 72)),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
