import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SparklineChart extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  
  const SparklineChart({
    super.key,
    required this.data,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }
    
    // Create spots from data, normalize x values from 0 to 1
    final spots = <FlSpot>[];
    final step = 1 / (data.length - 1);
    
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i * step, data[i]));
    }
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withOpacity(0.2),
            ),
          ),
        ],
        minY: data.reduce((a, b) => a < b ? a : b) * 0.95,
        maxY: data.reduce((a, b) => a > b ? a : b) * 1.05,
      ),
    );
  }
}