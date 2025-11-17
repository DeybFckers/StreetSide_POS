
class OrderModel {
  final int? id;
  final String name;
  final double totalAmount;
  final double amountGiven;
  final double change;
  final String orderType;
  final String paymentMethod;
  final String? orderStatus;
  final int discounted;
  final String createdAt;

  OrderModel({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.amountGiven,
    required this.change,
    required this.orderType,
    required this.paymentMethod,
    this.orderStatus,
    required this. discounted,
    required this.createdAt,

  });

  factory OrderModel.fromMap(Map<String, dynamic> map){
    return OrderModel(
        id: map['Order_Id'] as int,
        name: map['Customer_Name'] as String,
        totalAmount: (map['Total_Amount'] as num).toDouble(),
        amountGiven: (map['Amount_Given'] as num).toDouble(),
        change: (map['Change'] as num).toDouble(),
        orderType: map['Order_Type'] as String,
        paymentMethod: map['Payment_Method'] as String,
        orderStatus: map['Status'] as String? ?? 'In Progress',
        discounted: map['Discounted'] as int,
        createdAt: map['Created_At'] as String,
    );
  }
}