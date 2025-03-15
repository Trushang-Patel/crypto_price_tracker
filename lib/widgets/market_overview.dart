import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/crypto_provider.dart';

class MarketOverview extends StatelessWidget {
  const MarketOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, provider, child) {
        // Get best and worst performing coins from last 24h
        final coins = List.from(provider.coins);
        
        if (coins.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Sort by price change percentage
        coins.sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
        
        final bestPerformer = coins.first;
        final worstPerformer = coins.last;
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Market Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPerformanceCard(
                    context,
                    'Top Performer (24h)',
                    bestPerformer.name,
                    bestPerformer.symbol.toUpperCase(),
                    bestPerformer.priceChangePercentage24h,
                    Colors.green,
                    bestPerformer.image,
                  ),
                  const SizedBox(width: 8),
                  _buildPerformanceCard(
                    context,
                    'Worst Performer (24h)',
                    worstPerformer.name,
                    worstPerformer.symbol.toUpperCase(),
                    worstPerformer.priceChangePercentage24h,
                    Colors.red,
                    worstPerformer.image,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    String title,
    String name,
    String symbol,
    double priceChange,
    Color color,
    String imageUrl,
  ) {
    final percentFormat = NumberFormat('+0.00%;-0.00%');
    
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.network(imageUrl),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(symbol),
                  Text(
                    percentFormat.format(priceChange / 100),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
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