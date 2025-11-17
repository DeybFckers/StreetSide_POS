import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_pos/core/database/analytics_table.dart';
import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/features/analytics/models/analytics_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsData>> {
  AnalyticsNotifier() : super(const AsyncValue.loading());

  Future<void> loadAnalytics(String period) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = await StreetSideDatabase.instance.database;

      // Corrected typo here
      String tableName;
      switch (period) {
        case 'Weekly':
          tableName = AnalyticsTable.WeeklySalesTableName;
          break;
        case 'Monthly':
          tableName = AnalyticsTable.MonthlySalesTableName;
          break;
        default:
          tableName = AnalyticsTable.DailySalesTableName;
      }

      // Fetch sales data
      final sales = await db.query(
        tableName,
        limit: 7,
        orderBy: period == 'Daily' ? 'Sale_Date DESC' : null,
      );
      final salesData = sales.reversed.toList(); // keep chronological order

      // Totals and averages
      final totalSales = salesData.fold<double>(0.0, (sum, item) {
        final sales = item['Total_Sales'];
        return sum + (sales != null ? (sales as num).toDouble() : 0.0);
      });

      final totalOrders = salesData.fold<int>(0, (sum, item) {
        final orders = item['Total_Orders'];
        return sum + (orders != null ? orders as int : 0);
      });

      final avgOrder = totalOrders > 0 ? totalSales / totalOrders : 0.0;

      // Top products
      final topProducts = await db.query(
        AnalyticsTable.TopSellingTableName,
        limit: 5,
        orderBy: 'Total_Sold DESC',
      );

      // Category revenue
      final categoryRevenue = await db.query(
        AnalyticsTable.CategoryRevenueTableName,
        orderBy: 'Total_Revenue DESC',
      );

      return AnalyticsData(
        salesData: salesData,
        topProducts: topProducts,
        categoryRevenue: categoryRevenue,
        totalSales: totalSales,
        totalOrders: totalOrders,
        avgOrder: avgOrder,
      );
    });
  }
}

// Selected period provider
final selectedPeriodProvider = StateProvider<String>((ref) => 'Daily');

// Analytics notifier provider
final analyticsProvider =
StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsData>>(
        (ref) => AnalyticsNotifier());
