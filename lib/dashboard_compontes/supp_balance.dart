import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../minor_screens/sub_categ_products.dart';
import '../model/static_model.dart';
import '../widget/appber_widgets.dart';

class SupplierBalance extends StatelessWidget {
  const SupplierBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          double totalBlanc = 0.0;

          for (var element in snapshot.data!.docs) {
            totalBlanc += element['orderQty'] * element['orderPrice'];
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: AppBerTitle(title: 'Static'),
              leading: AppBeckButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StaticModel(
                    label: 'total blance ',
                    value: totalBlanc,
                    decimal: 2,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 40,
                    width:MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        color: Colors.pink, borderRadius: BorderRadius.circular(25)),
                    child: MaterialButton(
                      onPressed: (){},
                      child: Text('Get my Money!',style: TextStyle(color: Colors.white),),
                    ),
                  ),SizedBox(
                    height: 60,
                  ),

                ],
              ),
            ),
          );
        });
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic count;
  final dynamic decimal;

  const AnimatedCounter({super.key, required this.count, this.decimal});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
              child: Text(_animation.value.toStringAsFixed(widget.decimal),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acme',
                    letterSpacing: 2,
                    fontSize: 40,
                  )));
        });
  }
}
