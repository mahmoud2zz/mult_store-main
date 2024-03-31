import 'package:flutter/material.dart';
import 'package:mult_store/dashboard_compontes/supp_statics.dart';

class StaticModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final dynamic decimal;

  const StaticModel({
    super.key,
    required this.label,
    this.value, this.decimal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Center(
              child: Text(
                label.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 24),
              )),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    25,
                  ),
                  bottomRight: Radius.circular(25))),
          child: AnimatedCounter(count: value,decimal: decimal,)
        ),
      ],
    );
  }
}
