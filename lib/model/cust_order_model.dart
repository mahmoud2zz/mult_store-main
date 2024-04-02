import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mult_store/widget/yellow_button.dart';

class CustmorOrderModel extends StatelessWidget {
  CustmorOrderModel({
    super.key,
    required this.order,
  });

  final dynamic order;
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
                    child: Image.network(order['orderImage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                      order['orderName'],
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
                          Text(
                              ('\$ ') + order['orderPrice'].toStringAsFixed(2)),
                          Text(('x') + '${order['orderQty']}')
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
                order['deliveryStatus'],
              )
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: order['deliveryStatus'] == 'delivered'
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
                      ('Name: ') + (order['orderName']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone No: ') + (order['phone']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Email Address: ') + (order['email']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address: ') + (order['address']),
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          ('Payment status: '),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          order['paymentsStatus'],
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
                          order['deliveryStatus'],
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    order['deliveryStatus'] == 'shipping'
                        ? Text(('Estimated Delivery Data: ') +
                            DateFormat('yyyy--MM--dd')
                                .format(order['deliveryData'].toDate())
                                .toString())
                        : Text(''),
                    order['deliveryStatus'] == 'delivered' &&
                            order['orderReview'] == false
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
                                            children: [
                                              RatingBar.builder(
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
                                                    onPressed: () {
                                                      Navigator.pop(context);
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
                    order['deliveryStatus'] == 'delivered' &&
                            order['orderReview'] == true
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
