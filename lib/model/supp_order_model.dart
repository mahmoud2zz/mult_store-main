import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  const SupplierOrderModel({
    super.key,
    required this.order,
  });

  final QueryDocumentSnapshot<Object?> order;

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
                color: Colors.yellow.withOpacity(0.2),
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
                    Row(
                      children: [
                        Text(('Order Data: '), style: TextStyle(fontSize: 15)),
                        Text(
                          (DateFormat('yyyy_MM_dd')
                              .format(order['orderDate'].toDate())
                              .toString()),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    order['deliveryStatus'] == 'delivered'
                        ? Text('This Item han been already delivered')
                        : Row(
                            children: [
                              Text('Change Delivery  Stauts To',
                                  style: TextStyle(fontSize: 15)),
                              order['deliveryStatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(Duration(days: 365)),
                                            onConfirm: (data) async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderId'])
                                              .update({
                                            'deliveryStatus':'shipping',
                                            'deliveryData':data,
                                          });
                                        });
                                      },
                                      child: Text('shipping ?'))
                                  : TextButton(
                                      onPressed: ()async { await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order['orderId'])
                                          .update({
                                        'deliveryStatus':'delivered',

                                      });},
                                      child: Text('delivered ')),
                            ],
                          )
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
