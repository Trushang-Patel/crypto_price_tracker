import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PriceChart extends StatelessWidget {
  final List<List<num>> prices;
  final int timeRange;
  
  const PriceChart({
    super.key,
    required this.prices,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }
    
    // Get min and max values for y-axis
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    double minX = prices.first[0].toDouble();
    double maxX = prices.last[0].toDouble();
    
    // Format data points and calculate min/max values
    final spots = prices.map((point) {
      final price = point[1].toDouble();
      if (price < minY) minY = price;
      if (price > maxY) maxY = price;
      return FlSpot(point[0].toDouble(), price);
    }).toList();
    
    // Add some padding to min/max values
    final yPadding = (maxY - minY) * 0.05;
    minY -= yPadding;
    maxY += yPadding;
    
    // Calculate if the price trend is positive
    final isPositive = prices.first[1] < prices.last[1];
    final lineColor = isPositive ? Colors.green : Colors.red;
    final gradientColors = [
      lineColor.withOpacity(0.5),
      lineColor.withOpacity(0.05),
    ];
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) => _bottomTitleWidgets(value, meta, minX, maxX),
              interval: _getIntervalForTimeRange(minX, maxX),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => _leftTitleWidgets(value, meta),
              reservedSize: 55,
              interval: (maxY - minY) / 5,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [lineColor.withOpacity(0.8), lineColor],
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Theme.of(context).cardColor.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final timestamp = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                final formattedDate = DateFormat.yMd().add_Hm().format(timestamp);
                return LineTooltipItem(
                  '\$${flSpot.y.toStringAsFixed(2)}\n$formattedDate',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta, double minX, double maxX) {
    const style = TextStyle(
      color: Colors.white60,
      fontSize: 10,
    );
    
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    String text;
    
    switch (timeRange) {
      case 1:
        // For 24h, show hours
        text = DateFormat('HH:mm').format(date);
        break;
      case 7:
        // For 7d, show weekdays
        text = DateFormat('E').format(date);
        break;
      case 30:
      case 90:
        // For 30d and 90d, show day and month
        text = DateFormat('d MMM').format(date);
        break;
      case 365:
        // For 1y, show month
        text = DateFormat('MMM').format(date);
        break;
      default:
        text = DateFormat('d MMM').format(date);
    }
    
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white60,
      fontSize: 10,
    );
    
    String text;
    if (value >= 1000) {
      text = '\$${NumberFormat.compact().format(value)}';
    } else {
      text = '\$${value.toStringAsFixed(2)}';
    }
    
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  double _getIntervalForTimeRange(double minX, double maxX) {
    final totalRange = maxX - minX;
    
    switch (timeRange) {
      case 1:
        return totalRange / 6; // 6 intervals for 24h
      case 7:
        return totalRange / 7; // 1 per day for 7d
      case 30:
        return totalRange / 5; // 5 intervals for 30d
      case 90:
        return totalRange / 6; // 6 intervals for 90d
      case 365:
        return totalRange / 6; // 6 intervals for 1y
      default:
        return totalRange / 5;
    }
  }
}