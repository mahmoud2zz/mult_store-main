import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../model/product_model.dart';

class WomenGalleryScreen extends StatefulWidget {
  const WomenGalleryScreen({super.key});

  @override
  State<WomenGalleryScreen> createState() => _WomenGalleryScreenState();
}

class _WomenGalleryScreenState extends State<WomenGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCate', isEqualTo: 'women')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'this category  has \n \n items yet !',
                style: TextStyle(fontSize: 26, color: Colors.blueGrey,fontWeight:FontWeight.bold,fontFamily: 'Acme',letterSpacing: 1.5),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.size,
              crossAxisCount: 2,
              itemBuilder: (context, int index) {
                return ProductModel(products: snapshot.data!.docs[index],);
              },
              staggeredTileBuilder: (context) => StaggeredTile.fit(1),
            ),
          );
        });
  }
}

