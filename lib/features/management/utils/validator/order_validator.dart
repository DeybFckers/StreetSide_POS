class OrderValidator{
  static String? productQuantity(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Quantity';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid Quantity';
    }
    return null;
  }
}