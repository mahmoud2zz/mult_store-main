import 'package:flutter/material.dart';

import '../minor_screens/search_screen.dart';
class FackSearch extends StatelessWidget {
  const FackSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen())),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.yellow,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Waht are looking for?',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}