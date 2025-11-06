import 'package:flutter/material.dart';

class ContainerTab extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const ContainerTab({
    super.key,
    required this.icon,
    required this.name,
    this.isSelected = false,
    required this.onTap
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 121, 85, 72)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 2,
              color: isSelected
                  ? Color.fromARGB(255, 121, 85, 72)
                  : Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
