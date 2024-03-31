import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/main_screens/stores.dart';
import 'package:mult_store/main_screens/upload_product.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;


import 'category_screen.dart';
import 'dashpoard.dart';
import 'home_screen.dart';

class SupplerHomeScreen extends StatefulWidget {
  const SupplerHomeScreen({super.key});

  @override
  State<SupplerHomeScreen> createState() => _SupplerHomeScreenState();
}

class _SupplerHomeScreenState extends State<SupplerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> taps = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const DashboardScreen(),
    const UploadProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliveryStatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

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
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Category'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shop), label: 'Stores'),
                BottomNavigationBarItem(
                    icon:badges.Badge(
                        showBadge:
                        snapshot.data!.docs.isEmpty ? true : false,
                        badgeStyle: badges.BadgeStyle(badgeColor: Colors.yellow),
                        badgeContent: Text(
                          snapshot.data!.docs.length.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                        child: Icon(Icons.dashboard)), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.upload), label: 'Upload')
              ],
            ),
          );
        });
  }
}
