class AnalyticsData {
  final List<Map<String, dynamic>> salesData;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> categoryRevenue;
  final List<Map<String, dynamic>> paymentData; // Add this
  final double totalSales;
  final int totalOrders;
  final double avgOrder;
  final double totalCash; // Add this
  final double totalGcash; // Add this

  AnalyticsData({
    required this.salesData,
    required this.topProducts,
    required this.categoryRevenue,
    required this.paymentData, // Add this
    required this.totalSales,
    required this.totalOrders,
    required this.avgOrder,
    required this.totalCash, // Add this
    required this.totalGcash, // Add this
  });
}