import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/crypto_provider.dart';
import 'utils/theme_provider.dart';
import 'utils/favorites_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Crypto Price Tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              useMaterial3: true,
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF0F3460),
                secondary: const Color(0xFFE94560),
                surface: Colors.white,
                background: Colors.grey[100]!,
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF1A1A2E),
              cardColor: const Color(0xFF16213E),
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF0F3460),
                secondary: const Color(0xFFE94560),
                surface: const Color(0xFF16213E),
                background: const Color(0xFF1A1A2E),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    // Initialize data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CryptoProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}