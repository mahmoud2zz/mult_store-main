import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/customer_screens/add_address.dart';
import 'package:mult_store/widget/appber_widgets.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../model/product_model.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  Future<void> deAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(documentReference, {'default': false});
    });
  }

  Future<void> deAddressTrue(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customer['addressId']);
      transaction.update(documentReference, {'default': true});
    });
  }

  Future<void> updateProfile(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'address':
            '${customer['country']} _${customer['state']} _${customer['city']} ',
        'phone': customer['phone']
      });
    });
  }

  void showProgress(context) {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100, msg: 'place wait..', progressBgColor: Colors.red);
  }

  Future<void> deleteAddress(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customer['addressId']);
      transaction.delete(documentReference);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: AppBeckButton(),
        title: AppBerTitle(title: 'Address Book'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: addressStream,
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
                          'You  have set  \n \n an addrees yet',
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

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var customer = snapshot.data!.docs[index];
                          return Dismissible(
                            onDismissed: (value) async {
                              await deleteAddress(customer);
                            },
                            key: UniqueKey(),
                            child: InkWell(
                              onTap: () async {
                                showProgress(context);
                                for (var item in snapshot.data!.docs) {
                                  await deAddressFalse(item);
                                }
                                await deAddressTrue(customer)
                                    .whenComplete(() async {
                                  updateProfile(customer);
                                });
                                await Future.delayed(
                                        Duration(milliseconds: 100))
                                    .whenComplete(() => Navigator.pop(context));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Card(
                                  color: customer['default']
                                      ? Colors.white
                                      : Colors.yellow,
                                  child: ListTile(
                                    trailing: customer['default'] == true
                                        ? Icon(
                                            Icons.home,
                                            color: Colors.brown,
                                          )
                                        : SizedBox(),
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
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            YellowButton(
                label: 'Add New Address',
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAddress())),
                width: 0.8)
          ],
        ),
      ),
    );
  }
}
