class orderListModel {
  final int? OrderId;
  final String CustomerName;
  final String ProductName;
  final int Quantity;
  final double SubTotal;
  final double TotalAmount;
  final double AmountGiven;
  final double OrderChange;
  final String OrderType;
  final String PaymentMethod;
  String OrderStatus;
  final String Date;
  final String ProductImage;

  orderListModel ({
    this.OrderId,
    required this.CustomerName,
    required this.ProductName,
    required this.Quantity,
    required this.SubTotal,
    required this.TotalAmount,
    required this.AmountGiven,
    required this.OrderChange,
    required this.OrderType,
    required this.PaymentMethod,
    required this.OrderStatus,
    required this.Date,
    required this.ProductImage,
  });

  factory orderListModel.fromMap(Map<String, dynamic> map){
    return orderListModel(
      OrderId: map['orderId'] as int,
      CustomerName: map['Customer_Name'] as String,
      ProductName: map['Product_Name'] as String,
      Quantity: map['Quantity'] as int,
      SubTotal: (map['SubTotal'] as num).toDouble(),
      TotalAmount: (map['Total_Amount'] as num).toDouble(),
      AmountGiven: (map['Amount_Given'] as num).toDouble(),
      OrderChange: (map['Change'] as num).toDouble(),
      OrderType: map['Order_Type'] as String,
      PaymentMethod: map['Payment_Method'] as String,
      OrderStatus: map['Status'] as String,
      Date: map['Date'] as String,
      ProductImage: map['Product_Image'] as String,
    );
  }

}