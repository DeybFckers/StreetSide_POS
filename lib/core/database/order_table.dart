class OrderTable {
  //orders
  static const String OrderTableName = 'Orders';
  static const String OrderID ='Order_Id';
  static const String OrderCustomer = 'Customer_Name';
  static const String OrderTotalAmount = 'Total_Amount';
  static const String OrderAmountGiven = 'Amount_Given';
  static const String OrderChange = 'Change';
  static const String OrderCreatedAT = 'Created_At';

  //order_item
  static const String ItemTableName = 'Order_items';
  static const String ItemID = 'Item_Id';
  static const String ItemOrder = 'Order_Id';
  static const String ItemProduct = 'Product_Id';
  static const String ItemQuantity = 'Quantity';
  static const String ItemSubtotal = 'SubTotal';

}