import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../galleries/gallery_men.dart';
import '../galleries/women_gallery.dart';
import '../widget/fack_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(.5),
        appBar: AppBar(
          automaticallyImplyLeading: false,

            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.yellow,
              indicatorWeight: 8,
              tabs: [
                RepeatedTab(
                  label: 'Men',
                ),
                RepeatedTab(
                  label: 'Women',
                ),
                RepeatedTab(
                  label: 'Shoes',
                ),
                RepeatedTab(
                  label: 'Bages',
                ),
                RepeatedTab(
                  label: 'Electronics',
                ),
                RepeatedTab(label: 'Accessories'),
                RepeatedTab(
                  label: 'Home & Garden',
                ),
                RepeatedTab(
                  label: 'Kids',
                ),
                RepeatedTab(
                  label: 'Beauty',
                ),
              ],
            ),
            title: FackSearch()),
        body: TabBarView(
          children: [
            MenGalleryScreen(),
            WomenGalleryScreen(),
            Center(child: Text('shoes screen')),
            Center(child: Text('bages screen')),
            Center(child: Text('electronics screen')),
            Center(child: Text('Accessories screen')),
            Center(child: Text('home & garden screen')),
            Center(child: Text('kids screen')),
            Center(child: Text('beauty screen'))
          ],
        ),
      ),
    );
  }
}



class RepeatedTab extends StatelessWidget {
  final String label;

  const RepeatedTab({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Text(label, style: TextStyle(color: Colors.grey.shade500)));
  }
}
