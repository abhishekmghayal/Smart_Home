import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedMetric = 'AQI';

  final Map<String, List<double>> _metricData = {
    'AQI': [45, 50, 80, 110, 95, 100],
    'PM 2.5': [12, 15, 25, 45, 30, 28],
    'CO2': [400, 420, 600, 850, 700, 650],
    'Temp': [22, 22.5, 24, 25, 24.5, 23],
  };

  final Map<String, List<double>> _predictiveData = {
    'AQI': [100, 120, 135, 110],
    'PM 2.5': [28, 35, 40, 25],
    'CO2': [650, 700, 750, 600],
    'Temp': [23, 22, 21, 20],
  };

  final Map<String, double> _maxValues = {
    'AQI': 150,
    'PM 2.5': 60,
    'CO2': 1000,
    'Temp': 35,
  };

  // Color System (Consistent)
  final Color primaryColor = const Color(0xFF5E35B1);       // Purple/Blue theme
  final Color primaryColorLight = const Color(0xFFB39DDB);
  final Color successColor = const Color(0xFF388E3C);       // Green
  final Color warningColor = const Color(0xFFF57C00);       // Orange
  final Color textPrimary = const Color(0xFF2C3E50);
  final Color textSecondary = const Color(0xFF546E7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildMetricSelector(),
                const SizedBox(height: 28),
                _buildChartCard(),
                const SizedBox(height: 36),
                Text(
                  "Actionable Insights",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildInsightCard(
                  icon: Icons.air,
                  iconColor: warningColor,
                  title: "Ventilation Recommended",
                  richDescription: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
                      children: [
                        TextSpan(text: "CO2", style: TextStyle(fontWeight: FontWeight.bold, color: warningColor)),
                        const TextSpan(text: " levels are slightly rising. We recommend opening a window for "),
                        TextSpan(text: "15 minutes.", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInsightCard(
                  icon: Icons.eco_outlined,
                  iconColor: successColor,
                  title: "Toxins are Low",
                  richDescription: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
                      children: [
                        const TextSpan(text: "Your home has excellent "),
                        TextSpan(text: "VOC", style: TextStyle(fontWeight: FontWeight.bold, color: successColor)),
                        const TextSpan(text: " levels today. The air purifier is running efficiently on Eco mode."),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _buildReportButton(),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Environment Analytics",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: textPrimary,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.file_download_outlined, color: Color(0xFF455A64), size: 22),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMetricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none, // Allow shadows to be fully visible
      child: Row(
        children: ['AQI', 'PM 2.5', 'CO2', 'Temp'].map((metric) {
          final isSelected = _selectedMetric == metric;
          return GestureDetector(
            onTap: () {
              setState(() { _selectedMetric = metric; });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: Text(
                metric,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: 0.3,
                  color: isSelected ? Colors.white : textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 340,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50.withValues(alpha: 0.5),
          ],
        ),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$_selectedMetric Trends",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        "Live AI",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: LineChart(
                _mainChartData(),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(primaryColor, "Historical"),
              const SizedBox(width: 28),
              _buildLegendItem(primaryColorLight, "AI Predicted", isDashed: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget richDescription,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: iconColor.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                richDescription,
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReportButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.04), // Soft highlight
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.12), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          highlightColor: primaryColor.withValues(alpha: 0.08),
          splashColor: primaryColor.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assessment_outlined, color: primaryColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  "Generate Monthly Health Report",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _mainChartData() {
    final actual = _metricData[_selectedMetric]!;
    final predicted = _predictiveData[_selectedMetric]!;
    final maxY = _maxValues[_selectedMetric]!;

    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 3,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.12),
            strokeWidth: 1.5,
            dashArray: [8, 4],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 4,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xFF90A4AE), 
                fontWeight: FontWeight.w600, 
                fontSize: 12
              );
              String text = '${value.toInt()}:00';
              if (value == 18) text = 'Now';
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(text, style: style),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY / 3,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xFF90A4AE), 
                fontWeight: FontWeight.w600, 
                fontSize: 12
              );
              return Text(value.toInt().toString(), style: style, textAlign: TextAlign.right);
            },
            reservedSize: 36,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        // Historical Line
        LineChartBarData(
          spots: [
            FlSpot(0, actual[0]),
            FlSpot(4, actual[1]),
            FlSpot(8, actual[2]),
            FlSpot(12, actual[3]),
            FlSpot(16, actual[4]),
            FlSpot(18, actual[5]),
          ],
          isCurved: true,
          curveSmoothness: 0.35,
          color: primaryColor,
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                primaryColor.withValues(alpha: 0.15),
                primaryColor.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Predicted Line
        LineChartBarData(
          spots: [
            FlSpot(18, actual[5]),
            FlSpot(20, predicted[0]),
            FlSpot(22, predicted[1]),
            FlSpot(24, predicted[2]),
          ],
          isCurved: true,
          curveSmoothness: 0.35,
          color: primaryColorLight,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: primaryColorLight,
              );
            },
          ),
          dashArray: [6, 4], // More readable dashed line
        ),
      ],
    );
  }
}
