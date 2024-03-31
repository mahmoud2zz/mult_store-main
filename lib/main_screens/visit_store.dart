import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mult_store/minor_screens/sub_categ_products.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/product_model.dart';
import '../widget/appber_widgets.dart';

class VisitStore extends StatefulWidget {
  final String suppId;

  VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitState();
}

class _VisitState extends State<VisitStore> {
  bool following = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              toolbarHeight: 100,
              leading: AppBerYellowButton(),
              flexibleSpace: Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow, width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data['storeLogo'],
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    height: 100,
                    width: size.width * .5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'storeName'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.yellow),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        data['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: size.width * .3,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(width: 4, color: Colors.black),
                                ),
                                child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        following = !following;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('Edit'),
                                        Icon(Icons.edit)
                                      ],
                                    )),
                              )
                            : Container(
                                height: 35,
                                width: size.width * .3,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(width: 4, color: Colors.black),
                                ),
                                child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        following = !following;
                                      });
                                    },
                                    child: following == true
                                        ? Text('following',
                                            style:
                                                TextStyle(color: Colors.black))
                                        : Text(
                                            'FOLLWE',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _productStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Material(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'this category  has \n \n items yet !',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Acme',
                              letterSpacing: 1.5),
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
                          return ProductModel(
                            products: snapshot.data!.docs[index],
                          );
                        },
                        staggeredTileBuilder: (context) => StaggeredTile.fit(1),
                      ),
                    );
                  }),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child:const Icon(FontAwesomeIcons.whatsapp,size: 40,),
            ),
          );
        } else {
          return Text("loading");
        }
      },
    );
  }
}
