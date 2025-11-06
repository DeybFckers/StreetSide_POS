class AddValidator{

  static String? name(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Name';
    }
    return null;
  }

  static String? price(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Price';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  static String? category(String? value){
    if(value == null || value.isEmpty){
      return 'Please select a Product Category';
    }
    return null;
  }

  static String? filename(String? value){
    if(value == null || value.isEmpty){
      return  'Please select a file';
    }
    return null;
  }
}