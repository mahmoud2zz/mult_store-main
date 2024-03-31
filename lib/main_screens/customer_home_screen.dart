import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/main_screens/profile.dart';
import 'package:mult_store/main_screens/stores.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../customer_screens/cart.dart';
import '../providers/cart_providers.dart';
import 'cart.dart';
import 'category_screen.dart';
import 'home_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> taps = [
    HomeScreen(),
    CategoryScreen(),
    StoresScreen(),
    CartScreen(),
    ProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: taps[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.black,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Category'),
          BottomNavigationBarItem(
              icon: badges.Badge(
                showBadge:
                    context.read<Cart>().getItems.isNotEmpty ? true : false,
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.yellow),
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                child: Icon(Icons.shopping_cart),
              ),
              label: 'Stores'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}
