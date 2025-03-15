import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crypto_provider.dart';
import '../utils/favorites_provider.dart';
import '../widgets/coin_list_item.dart';
import 'coin_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, CryptoProvider>(
      builder: (context, favoritesProvider, cryptoProvider, child) {
        if (!favoritesProvider.isLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final favoriteIds = favoritesProvider.getFavoriteIds();
        
        if (favoriteIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_border,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add coins to your favorites by tapping the star icon',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        // Filter coins list to only show favorites
        final favoriteCoins = cryptoProvider.coins
            .where((coin) => favoriteIds.contains(coin.id))
            .toList();
        
        if (favoriteCoins.isEmpty && cryptoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (favoriteCoins.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading favorites...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    cryptoProvider.fetchCoins();
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => cryptoProvider.fetchCoins(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favoriteCoins.length,
            itemBuilder: (context, index) {
              final coin = favoriteCoins[index];
              return CoinListItem(
                coin: coin,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoinDetailScreen(coinId: coin.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}