import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/customer_screens/add_address.dart';
import 'package:mult_store/customer_screens/address_book.dart';
import 'package:mult_store/minor_screens/payment_screen.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:provider/provider.dart';

import '../providers/cart_providers.dart';
import '../widget/appber_widgets.dart';

class PlaceOrderScreen extends StatelessWidget {
  PlaceOrderScreen({super.key});
  late String name;

  late String phone;

  late String address;

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .where('default', isEqualTo: true)
        .limit(1)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // if (snapshot.data!.docs.isEmpty) {
          //   return Center(
          //     child: Text(
          //       'this category  has \n \n items yet !',
          //       style: TextStyle(
          //           fontSize: 26,
          //           color: Colors.blueGrey,
          //           fontWeight: FontWeight.bold,
          //           fontFamily: 'Acme',
          //           letterSpacing: 1.5),
          //       textAlign: TextAlign.center,
          //     ),
          //   );
          // }

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
                      snapshot.data!.docs.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAddress()));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: ListView.builder(
                                      itemBuilder: (context, index) {
                                    var customer = snapshot.data!.docs[index];
                                    name = customer['firstName'] +
                                        customer['lastName'];
                                    phone = customer['phone'];
                                    address = customer['country'] +
                                        '_' +
                                        customer['state'] +
                                        '_' +
                                        customer['city'];
                                    return ListTile(
                                      title: SizedBox(
                                        height: 50,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${customer['firstName']} ${customer['lastName']}'),
                                            Text('${customer['phone']}')
                                          ],
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                        height: 70,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'city/state   :${customer['city']} : ${customer['state']}'),
                                            Text(
                                                'country:  ${customer['country']}')
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressBook()));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 140,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: Text(
                                    'set your Addrees',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        letterSpacing: 1.5,
                                        fontSize: 24,
                                        fontFamily: 'Acme',
                                        fontWeight: FontWeight.w600),
                                  ),
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
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(14),
                                                topRight: Radius.circular(14)),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                  order.imageUrl.first),
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                order.name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.grey.shade600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      order.price
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    Text(
                                                      'x ${order.qty.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600),
                                                    )
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
                    padding: EdgeInsets.all(8.0),
                    child: YellowButton(
                      label:
                          'Confirm ${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD',
                      onPressed: snapshot.data!.docs.isEmpty
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressBook()))
                          : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        name: name,
                                        phone: phone,
                                        address: address,
                                      ))),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
