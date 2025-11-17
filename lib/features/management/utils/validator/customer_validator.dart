class CustomerValidator{

  static String? amountGiven(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Amount Given';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

}