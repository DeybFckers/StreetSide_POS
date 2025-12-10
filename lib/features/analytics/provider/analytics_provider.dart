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

      // Determine table names based on period
      String salesTableName;
      String paymentTableName;
      String orderByClause;
      
      switch (period) {
        case 'Weekly':
          salesTableName = AnalyticsTable.WeeklySalesTableName;
          paymentTableName = AnalyticsTable.WeeklyPaymentTableName;
          orderByClause = 'Week DESC';
          break;
        case 'Monthly':
          salesTableName = AnalyticsTable.MonthlySalesTableName;
          paymentTableName = AnalyticsTable.MonthlyPaymentTableName;
          orderByClause = 'Month DESC';
          break;
        default:
          salesTableName = AnalyticsTable.DailySalesTableName;
          paymentTableName = AnalyticsTable.DailyPaymentTableName;
          orderByClause = 'Sale_Date DESC';
      }

      // Fetch sales data
      final sales = await db.query(
        salesTableName,
        limit: 7,
        orderBy: orderByClause,
      );
      final salesData = sales.reversed.toList();

      // Fetch payment data
      final payments = await db.query(
        paymentTableName,
        limit: 7,
        orderBy: orderByClause,
      );
      final paymentData = payments.reversed.toList();

      // Calculate totals
      final totalSales = salesData.fold<double>(0.0, (sum, item) {
        final sales = item['Total_Sales'];
        return sum + (sales != null ? (sales as num).toDouble() : 0.0);
      });

      final totalOrders = salesData.fold<int>(0, (sum, item) {
        final orders = item['Total_Orders'];
        return sum + (orders != null ? orders as int : 0);
      });

      final avgOrder = totalOrders > 0 ? totalSales / totalOrders : 0.0;

      // Calculate payment totals
      final totalCash = paymentData.fold<double>(0.0, (sum, item) {
        final cash = item['Total_Cash'];
        return sum + (cash != null ? (cash as num).toDouble() : 0.0);
      });

      final totalGcash = paymentData.fold<double>(0.0, (sum, item) {
        final gcash = item['Total_Gcash'];
        return sum + (gcash != null ? (gcash as num).toDouble() : 0.0);
      });

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
        paymentData: paymentData,
        totalSales: totalSales,
        totalOrders: totalOrders,
        avgOrder: avgOrder,
        totalCash: totalCash,
        totalGcash: totalGcash,
      );
    });
  }
}

final selectedPeriodProvider = StateProvider<String>((ref) => 'Daily');

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsData>>(
        (ref) => AnalyticsNotifier());