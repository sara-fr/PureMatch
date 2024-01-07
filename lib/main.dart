import 'package:flutter/material.dart';
import 'package:pure_match/appSettings.dart';
import 'package:pure_match/homeUI.dart';
import 'package:pure_match/menuItems.dart';
import 'package:pure_match/searchUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // The root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pure Match',

      // light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // dark theme settings
      darkTheme: themeData,

      themeMode: ThemeMode.dark,

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Bottom navigation bar UI views and controller
  final PageController _screensController = PageController(initialPage: 0, keepPage: true);
  static const List<Widget> _Screens = [search(), homeUI(), homeUI(), homeUI()];
  int _selectedIndex = 0;

  // Change the screen/page index of the bottom navigation menu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _screensController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(

        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          padding: const EdgeInsets.all(0),
          child: PageView(
            controller: _screensController,
            children: _Screens,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              _onItemTapped(index);
            },
          ),
        ),

        // Bottom navigation menu bar of the main screen view
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          unselectedItemColor: const Color(0xFF8E8E8E),
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          iconSize: 20,
          currentIndex: _selectedIndex,
          onTap: (index) {
            _onItemTapped(index);
            setState(() {
              _screensController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            });
          },
          items: menuItems(),
        ),
      ),
    );
  }
}