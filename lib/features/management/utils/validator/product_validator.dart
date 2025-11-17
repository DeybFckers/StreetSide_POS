class ProductValidator{

  static String? productName(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Name';
    }
    return null;
  }

  static String? productCategory(String? value){
    if(value == null || value.isEmpty){
      return 'Please select a Product Category';
    }
    return null;
  }
  static String? productPrice(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Price';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  static String? productFilename(String? value){
    if(value == null || value.isEmpty){
      return  'Please select a file';
    }
    return null;
  }
}