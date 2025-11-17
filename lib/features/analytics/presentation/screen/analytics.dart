import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_pos/features/analytics/provider/analytics_provider.dart';
import 'package:coffee_pos/features/analytics/models/analytics_model.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/sales_chart.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/summary_card.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/top_products.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/category_revenue.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/period_selector.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final period = ref.read(selectedPeriodProvider);
      ref.read(analyticsProvider.notifier).loadAnalytics(period);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analyticsData = ref.watch(analyticsProvider);
    final selectedPeriod = ref.watch(selectedPeriodProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4E342E),
        title: Text(
          'Analytics',
          style: theme.textTheme.titleLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      drawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 237, 224),
        ),
        child: analyticsData.when(
          data: (data) => _buildContent(context, data, selectedPeriod),
          loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 3)),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, AnalyticsData data, String period) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(analyticsProvider.notifier).loadAnalytics(period);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PeriodSelector(
              selectedPeriod: period,
              onChanged: (newPeriod) async {
                ref.read(selectedPeriodProvider.notifier).state = newPeriod;
                await ref
                    .read(analyticsProvider.notifier)
                    .loadAnalytics(newPeriod);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Sales',
                    value: '₱${data.totalSales.toStringAsFixed(2)}',
                    icon: Icons.trending_up,
                    color: const Color(0xFF4CAF50),
                    subtitle: 'Revenue generated',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Total Orders',
                    value: data.totalOrders.toString(),
                    icon: Icons.receipt_long,
                    color: const Color(0xFF2196F3),
                    subtitle: 'Completed orders',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Avg Order',
                    value: '₱${data.avgOrder.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: const Color(0xFFFF9800),
                    subtitle: 'Per transaction',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SalesChart(salesData: data.salesData, selectedPeriod: period),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: TopSellingProducts(products: data.topProducts)),
                const SizedBox(width: 16),
                Expanded(child: CategoryRevenue(categories: data.categoryRevenue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
