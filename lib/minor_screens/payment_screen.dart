import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mult_store/minor_screens/payment_screen.dart';
import 'package:mult_store/widget/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../customer_screens/wilshlist_.dart';
import '../main_screens/profile.dart';
import '../model/stripe_id.dart';
import '../providers/cart_providers.dart';
import '../widget/alert_dialog.dart';
import '../widget/appber_widgets.dart';
import '../widget/categ_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String orderId;
  int selectedValue = 1;

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100, msg: 'place wait..', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;

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
                      title: 'Payment ',
                    ),
                  ),
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 120,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text('${totalPaid.toStringAsFixed(2)} USD',
                                        style: TextStyle(fontSize: 20))
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' Total order',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                        '${totalPrice.toStringAsFixed(2)} USD ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shippin Coast',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text('10.0  ' + ('USD'),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey))
                                  ],
                                ),
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
                            child: Column(
                              children: [
                                LabeledRadio(
                                  title: 'Cash on Delivery',
                                  widget: Text('Pay Cash  At Home'),
                                  groupValue: selectedValue,
                                  value: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                                LabeledRadio(
                                  title: 'Pay via visa / Master Card',
                                  widget: Row(
                                    children: [
                                      Icon(
                                        Icons.payment_outlined,
                                        color: Colors.blue,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccVisa,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                  groupValue: selectedValue,
                                  value: 2,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                                LabeledRadio(
                                  title: 'Pay via Paypal',
                                  widget: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.paypal,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                  groupValue: selectedValue,
                                  value: 3,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label:
                            'Confirm ${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD',
                        onPressed: () async {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                                context: (context),
                                builder: (context) => SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 100),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Pay at Home ${totalPaid.toStringAsFixed(2)} \$',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            YellowButton(
                                                label:
                                                    'Confirm${totalPrice.toStringAsFixed(2)}',
                                                onPressed: () async {
                                                  showProgress();
                                                  for (var item in context
                                                      .read<Cart>()
                                                      .getItems) {
                                                    CollectionReference
                                                        orderRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'orders');
                                                    orderId = Uuid().v4();
                                                    await orderRef
                                                        .doc(orderId)
                                                        .set({
                                                      'cid': data['cid'],
                                                      'custName': data['name'],
                                                      'email': data['email'],
                                                      'address':
                                                          data['address'],
                                                      'phone': data['phone'],
                                                      'profileImage':
                                                          data['profileImage'],
                                                      'sid': item.suppId,
                                                      'proId': item.documentId,
                                                      'orderId': orderId,
                                                      'orderName': item.name,
                                                      'orderImage':
                                                          item.imageUrl.first,
                                                      'orderPrice': item.price,
                                                      'orderQty': item.qty,
                                                      'deliveryStatus':
                                                          'preparing',
                                                      'deliveryData': '',
                                                      'orderDate':
                                                          DateTime.now(),
                                                      'paymentsStatus':
                                                          'cash on delivery',
                                                      'orderReview': false
                                                    }).whenComplete(() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                              (transaction) async {
                                                        DocumentReference
                                                            documentReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(item
                                                                    .documentId);
                                                        DocumentSnapshot
                                                            documentSnapshot =
                                                            await transaction.get(
                                                                documentReference);
                                                        transaction.update(
                                                            documentReference, {
                                                          'instock':
                                                              documentSnapshot[
                                                                      'instock'] -
                                                                  item.qty,
                                                        });
                                                      });
                                                    });
                                                  }
                                                  context
                                                      .read<Cart>()
                                                      .clearCart();
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          '/customer_home'));
                                                },
                                                width: 0.9)
                                          ],
                                        ),
                                      ),
                                    ));
                          } else if (selectedValue == 2) {
                            await mackPayment();
                          } else if (selectedValue == 3) {
                            await mackPayment();
                          }
                        },
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

  Map<dynamic, dynamic>? paymentIntentDate;
  Future<void> mackPayment() async {
    paymentIntentDate = await createPaymentIntent();
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'ANNIE',
        paymentIntentClientSecret: paymentIntentDate!['client_secret'],
        allowsDelayedPaymentMethods: true,
        applePay: PaymentSheetApplePay(merchantCountryCode: 'US'),
        googlePay: PaymentSheetGooglePay(
          merchantCountryCode: 'US',
        ),
      ));

      await displayPaymentSheet();
    } catch (e) {
      print('___1');
      print(e.toString());
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        'amount': '1200',
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };
      final response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey ',
            'Content_Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (e) {
      print('___');
      print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        setState(() {
          paymentIntentDate = null;
        });
      });

      print('Done');
    } catch (e) {
      print('failed');
      print(e.toString());
    }
  }
}

class LabeledRadio extends StatelessWidget {
  final String title;
  final Widget widget;
  final int groupValue;
  final int value;
  final Function onChanged;

  LabeledRadio(
      {super.key,
      required this.title,
      required this.widget,
      required this.groupValue,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: ListTile(
        leading: Icon(
          Icons.attach_money,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(title),
        subtitle: widget,
        trailing: Radio<int>(
          groupValue: groupValue,
          value: value,
          onChanged: (newValue) {
            onChanged(newValue);
          },
        ),
      ),
    );
  }
}
