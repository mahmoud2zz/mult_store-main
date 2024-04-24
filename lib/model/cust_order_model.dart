import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mult_store/widget/yellow_button.dart';

class CustmorOrderModel extends StatefulWidget {
  CustmorOrderModel({
    super.key,
    required this.order,
  });

  final dynamic order;

  @override
  State<CustmorOrderModel> createState() => _CustmorOrderModelState();
}

class _CustmorOrderModelState extends State<CustmorOrderModel> {
  late double rate;

  late String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
        child: ExpansionTile(
          title: Container(
            constraints: BoxConstraints(
              maxHeight: 100,
              maxWidth: double.infinity,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderImage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                      widget.order['orderName'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(('\$ ') +
                              widget.order['orderPrice'].toStringAsFixed(2)),
                          Text(('x') + '${widget.order['orderQty']}')
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('See More ..'),
              Text(
                widget.order['deliveryStatus'],
              )
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.order['deliveryStatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name: ') + (widget.order['orderName']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone No: ') + (widget.order['phone']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Email Address: ') + (widget.order['email']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address: ') + (widget.order['address']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          ('Payment status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          widget.order['paymentsStatus'],
                          style:
                              TextStyle(color: Colors.deepPurple, fontSize: 15),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(('Delivery status: '),
                            style: TextStyle(fontSize: 15)),
                        Text(
                          widget.order['deliveryStatus'],
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    widget.order['deliveryStatus'] == 'shipping'
                        ? Text(('Estimated Delivery Data: ') +
                            DateFormat('yyyy--MM--dd')
                                .format(widget.order['deliveryData'].toDate())
                                .toString())
                        : Text(''),
                    widget.order['deliveryStatus'] == 'delivered' &&
                            widget.order['orderReview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: (context),
                                  builder: (context) => Material(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RatingBar.builder(
                                                allowHalfRating: true,
                                                initialRating: 1,
                                                maxRating: 2,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  rate = rating;
                                                },
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Enter your review',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide:
                                                              BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.yellow,
                                                          )),
                                                ),
                                                onChanged: (value) {
                                                  comment = value;
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  YellowButton(
                                                    label: 'cancel',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    width: 0.3,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  YellowButton(
                                                    label: 'OK',
                                                    onPressed: () async {
                                                      CollectionReference
                                                          collRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(widget.order[
                                                                  'proId'])
                                                              .collection(
                                                                  'reviews');

                                                      await collRef
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        'name': widget
                                                            .order['custName'],
                                                        'email': widget
                                                            .order['email'],
                                                        'rate': rate,
                                                        'comment': comment,
                                                        'profileImage': widget
                                                                    .order[
                                                                'profileImage'] ??
                                                            ''
                                                      }).whenComplete(() async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          DocumentReference
                                                              documentReference =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(widget
                                                                          .order[
                                                                      'orderId']);
                                                          await transaction.update(
                                                              documentReference,
                                                              {
                                                                'orderReviews':
                                                                    true,
                                                              });
                                                        });
                                                      });
                                                      await Future.delayed(
                                                              Duration(
                                                                  microseconds:
                                                                      100))
                                                          .whenComplete(() {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    width: 0.3,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: Text('Write Reviwe'))
                        : Text(''),
                    widget.order['deliveryStatus'] == 'delivered' &&
                            widget.order['orderReview'] == true
                        ? Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                ' Reviwe Add',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          )
                        : Text('')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
