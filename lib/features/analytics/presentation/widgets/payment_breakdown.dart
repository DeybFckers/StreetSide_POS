import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentBreakdown extends StatelessWidget {
  final double totalCash;
  final double totalGcash;
  final List<Map<String, dynamic>> paymentData;
  final String selectedPeriod;

  const PaymentBreakdown({
    super.key,
    required this.totalCash,
    required this.totalGcash,
    required this.paymentData,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final totalPayments = totalCash + totalGcash;
    final cashPercentage = totalPayments > 0 ? (totalCash / totalPayments * 100) : 0.0;
    final gcashPercentage = totalPayments > 0 ? (totalGcash / totalPayments * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4E342E).withOpacity(0.2),
                      const Color(0xFF4E342E).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.payment, color: Color(0xFF4E342E), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pie Chart
          if (totalPayments > 0)
            Center(
              child: SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF4CAF50),
                        value: totalCash,
                        title: '${cashPercentage.toStringAsFixed(1)}%',
                        radius: 55,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF2196F3),
                        value: totalGcash,
                        title: '${gcashPercentage.toStringAsFixed(1)}%',
                        radius: 55,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.payment_outlined, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text(
                      'No payment data available',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Cash breakdown
          _buildPaymentCard(
            'Cash',
            totalCash,
            cashPercentage,
            const Color(0xFF4CAF50),
            Icons.money,
          ),
          const SizedBox(height: 12),

          // GCash breakdown
          _buildPaymentCard(
            'GCash',
            totalGcash,
            gcashPercentage,
            const Color(0xFF2196F3),
            Icons.phone_android,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    String method,
    double amount,
    double percentage,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${percentage.toStringAsFixed(1)}% of total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₱${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}