import 'package:flutter/material.dart';

import '../categories/accessories_categ.dart';
import '../categories/beauty_categ.dart';
import '../categories/electronics_categ.dart';
import '../categories/home_garden_categ.dart';
import '../categories/kids_categ.dart';
import '../categories/men_categ.dart';
import '../categories/pags_cage.dart';
import '../categories/shoes_categ.dart';
import '../categories/women_categ.dart';
import '../widget/fack_search.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int index=0;


  final PageController _pageController = PageController();
  List<ItemData> items = [
    ItemData(label: 'men'),
    ItemData(label: 'women'),
    ItemData(label: 'shoes'),
    ItemData(label: 'bags '),
    ItemData(label: 'electronics'),
    ItemData(label: 'accessories'),
    ItemData(label: 'home & garden'),
    ItemData(label: 'kids'),
    ItemData(label: 'beauty'),

  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FackSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size: size)),
          Positioned(bottom: 0, right: 0, child: cateView(size: size))
        ],
      ),
    );
  }

  Container cateView({required Size size}) {
    return Container(
      color: Colors.white,
      width: size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.9,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          items.forEach((element) {
            element.selected = false;
          });
          setState(() {

            items[value].selected = true;
          });


        },
        scrollDirection: Axis.vertical,
        children:   [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),

          BagsCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeandGardenCategory(),
          KidsCategory(),
          BeautyCategory()
        ],
      ),
    );
  }

  Widget sideNavigator({required Size size}) {
    return GestureDetector(
      child: SizedBox(
        width: size.width * 0.2,
        height: size.height * 0.8,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: Duration(
                        milliseconds: 1000,
                      ),
                      curve: Curves.bounceInOut);
                },
                child: Container(
                  color: items[index].selected == true
                      ? Colors.white
                      : Colors.grey.shade300,
                  height: 100,
                  child: Text(items[index].label),
                ),
              );
            }),
      ),
    );
  }
}

class ItemData {
  late String label;
  late bool selected;

  ItemData({required this.label, this.selected = false});
}
