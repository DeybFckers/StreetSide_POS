import 'package:coffee_pos/core/widgets/my_drawer.dart';
import 'package:coffee_pos/core/widgets/tablecheck.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 52, 46),
        title: Row(
          children: [
            Expanded(
              child: Text('Analytics',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TableCheck()
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
