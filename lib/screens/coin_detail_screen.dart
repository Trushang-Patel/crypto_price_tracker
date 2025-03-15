import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/crypto_provider.dart';
import '../widgets/price_chart.dart';
import '../models/chart_data.dart';
import '../models/coin.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;
  
  const CoinDetailScreen({
    super.key,
    required this.coinId,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  final List<int> _timeRanges = [1, 7, 30, 90, 365];
  int _selectedTimeRange = 7;
  final currencyFormat = NumberFormat.currency(symbol: '\$');
  final percentFormat = NumberFormat('+0.00%;-0.00%');
  
  @override
  void initState() {
    super.initState();
    _selectedTimeRange = Provider.of<CryptoProvider>(context, listen: false).selectedTimeRange;
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, provider, _) {
        final coin = provider.getCoinById(widget.coinId);
        
        if (coin == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Coin Detail')),
            body: const Center(child: Text('Coin not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Image.network(coin.image),
                ),
                const SizedBox(width: 8),
                Text('${coin.name} (${coin.symbol.toUpperCase()})'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  provider.refreshChartData();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceHeader(coin),
                  const SizedBox(height: 24),
                  _buildTimeRangeSelector(),
                  const SizedBox(height: 8),
                  _buildChart(provider),
                  const SizedBox(height: 24),
                  _buildStatistics(coin),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceHeader(Coin coin) {
    final priceChange = coin.priceChangePercentage24h;
    final color = priceChange >= 0 ? Colors.green : Colors.red;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyFormat.format(coin.currentPrice),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              priceChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${priceChange.abs().toStringAsFixed(2)}% (24h)',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _timeRanges.map((days) {
          final isSelected = days == _selectedTimeRange;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(_getTimeRangeLabel(days)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTimeRange = days;
                  });
                  Provider.of<CryptoProvider>(context, listen: false)
                      .setTimeRange(days);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getTimeRangeLabel(int days) {
    switch (days) {
      case 1:
        return '24h';
      case 7:
        return '7d';
      case 30:
        return '30d';
      case 90:
        return '90d';
      case 365:
        return '1y';
      default:
        return '${days}d';
    }
  }

  Widget _buildChart(CryptoProvider provider) {
    return FutureBuilder<ChartData?>(
      future: provider.getCoinChartData(widget.coinId, _selectedTimeRange),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError || snapshot.data == null) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Text('Failed to load chart data'),
            ),
          );
        }
        
        final chartData = snapshot.data!;
        return SizedBox(
          height: 250,
          child: PriceChart(
            prices: chartData.prices,
            timeRange: _selectedTimeRange,
          ),
        );
      },
    );
  }

  Widget _buildStatistics(Coin coin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Statistics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildStatItem('Market Cap', currencyFormat.format(coin.marketCap)),
        _buildStatItem('Market Cap Rank', '#${coin.marketCapRank}'),
        _buildStatItem('24h High', currencyFormat.format(coin.high24h)),
        _buildStatItem('24h Low', currencyFormat.format(coin.low24h)),
        _buildStatItem('Circulating Supply', '${coin.circulatingSupply.toStringAsFixed(0)} ${coin.symbol.toUpperCase()}'),
        if (coin.totalSupply > 0)
          _buildStatItem('Total Supply', '${coin.totalSupply.toStringAsFixed(0)} ${coin.symbol.toUpperCase()}'),
        if (coin.maxSupply > 0)
          _buildStatItem('Max Supply', '${coin.maxSupply.toStringAsFixed(0)} ${coin.symbol.toUpperCase()}'),
        _buildStatItem('Price Change (1h)', percentFormat.format(coin.priceChangePercentage1hInCurrency / 100)),
        _buildStatItem('Price Change (24h)', percentFormat.format(coin.priceChangePercentage24hInCurrency / 100)),
        _buildStatItem('Price Change (7d)', percentFormat.format(coin.priceChangePercentage7dInCurrency / 100)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}