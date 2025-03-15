import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/coin.dart';
import 'sparkline_chart.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;
  
  const CoinListItem({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final priceChange = coin.priceChangePercentage24h;
    final color = priceChange >= 0 ? Colors.green : Colors.red;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Coin image
              SizedBox(
                width: 40,
                height: 40,
                child: Image.network(coin.image),
              ),
              const SizedBox(width: 16),
              
              // Coin details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Mini sparkline chart
              if (coin.sparklineIn7d.isNotEmpty)
                SizedBox(
                  width: 60,
                  height: 30,
                  child: SparklineChart(
                    data: coin.sparklineIn7d,
                    lineColor: priceChange >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(width: 16),
              
              // Price and change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(coin.currentPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        priceChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: color,
                        size: 12,
                      ),
                      Text(
                        '${priceChange.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}