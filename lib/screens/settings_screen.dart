import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            subtitle: const Text('USD'),
            onTap: () {
              _showCurrencyPicker(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Refresh Interval'),
            subtitle: const Text('Every 60 seconds'),
            onTap: () {
              _showRefreshIntervalPicker(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Crypto Price Tracker v1.0.0'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: Constants.supportedCurrencies.length,
              itemBuilder: (context, index) {
                final entry = Constants.supportedCurrencies.entries.elementAt(index);
                return ListTile(
                  leading: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(entry.key.toUpperCase()),
                  onTap: () {
                    // TODO: Implement currency changing logic
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  void _showRefreshIntervalPicker(BuildContext context) {
    final intervals = [30, 60, 300, 600];
    final intervalLabels = ['30 seconds', '1 minute', '5 minutes', '10 minutes'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Refresh Interval'),
          content: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: ListView.builder(
              itemCount: intervals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(intervalLabels[index]),
                  onTap: () {
                    // TODO: Implement refresh interval changing logic
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Crypto Price Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 32),
      children: [
        const Text(
          'A cryptocurrency price tracker app that fetches real-time prices and visualizes trends using charts.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Data provided by CoinGecko API',
        ),
      ],
    );
  }
}