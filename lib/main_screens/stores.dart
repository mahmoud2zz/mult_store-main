import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/main_screens/visit_store.dart';

import '../widget/appber_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBerTitle(
          title: 'Stroes',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('suppliers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap:(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> VisitStore(suppId: snapshot.data!.docs[index]['sid'],)));
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image(
                                  image: AssetImage('images/inapp/store.jpg'),
                                ),
                              ),
                              Positioned(
                                bottom: 28,
                                  left: 10,
                                  child: SizedBox(
                                    height: 48,
                                    width: 100,
                                    child: Image.network(
                                        snapshot.data!.docs[index]['storeLogo'].toString(),fit: BoxFit.fill,),
                                  ))
                            ],
                          ),
                          Text(
                            snapshot.data!.docs[index]['storeName'],
                            style: TextStyle(
                                fontSize: 26, fontFamily: 'AkayaTelivigala'),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text('No Stores'),
              );
            }
          },
        ),
      ),
    );
  }
}
