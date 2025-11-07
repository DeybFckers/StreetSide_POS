
class OrderModel {
  final int? id;
  final String name;
  final double totalAmount;
  final double amountGiven;
  final double change;
  final String createdAt;

  OrderModel({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.amountGiven,
    required this.change,
    required this.createdAt,

  });

  factory OrderModel.fromMap(Map<String, dynamic> map){
    return OrderModel(
        id: map['Order_Id'] as int,
        name: map['Customer_Name'] as String,
        totalAmount: (map['Total_Amount'] as num).toDouble(),
        amountGiven: (map['Amount_Given'] as num).toDouble(),
        change: (map['Change'] as num).toDouble(),
        createdAt: map['Created_At'] as String,
    );
  }
}