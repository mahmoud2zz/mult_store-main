import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/minor_screens/payment_screen.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:provider/provider.dart';

import '../customer_screens/wilshlist_.dart';
import '../main_screens/profile.dart';
import '../providers/cart_providers.dart';
import '../widget/alert_dialog.dart';
import '../widget/appber_widgets.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
  double totalPrice  =context.watch<Cart>().totalPrice;
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Material(child: Center(child: CircularProgressIndicator(),),);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    leading: AppBeckButton(),
                    automaticallyImplyLeading: false,
                    title: AppBerTitle(
                      title: 'Plasc Order',
                    ),
                  ),
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Name:${data['name']}'),
                                Text('Phone:${data['phone']}'),
                                Text('Address:${data['address']}')
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Consumer<Cart>(
                            builder: (context, cart, index) {
                              return ListView.builder(
                                  itemCount: cart.count,
                                  itemBuilder: (context, index) {
                                    final order = cart.getItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(14),
                                                  topRight:
                                                      Radius.circular(14)),
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    order.imageUrl.first),
                                              ),
                                            ),
                                            Flexible(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                                  children: [
                                                Text(
                                                  order.name,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,color: Colors.grey.shade600),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                    children: [
                                                      Text(order.price
                                                          .toStringAsFixed(2),style:TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.w600,color: Colors.grey.shade600) ,),
                                                      Text('x ${order.qty.toString()}',style:TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.w600,color: Colors.grey.shade600) ,)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label:'Confirm ${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD',
                        onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen())),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
