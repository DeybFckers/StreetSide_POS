class ItemModel {
  final int? id;
  final int? orderId;
  final int productId;
  final int quantity;
  final double subTotal;

  ItemModel({
    this.id,
    this.orderId,
    required this.productId,
    required this.quantity,
    required this.subTotal,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map){
    return ItemModel(
        id: map['Item_Id'] as int,
        orderId: map['Order_Id'] as int,
        productId: map['Product_Id'] as int,
        quantity: map['Quantity'] as int,
        subTotal: (map['SubTotal'] as num).toDouble(),
    );
  }
}