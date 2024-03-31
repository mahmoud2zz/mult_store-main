import 'package:flutter/material.dart';
import 'package:mult_store/dashboard_compontes/preparing_odrers.dart';
import 'package:mult_store/dashboard_compontes/shipping_oders.dart';
import '../minor_screens/sub_categ_products.dart';
import '../widget/appber_widgets.dart';
import 'delivered_orders.dart';

class SupplierOrder extends StatelessWidget {
  const SupplierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(child: AppBerTitle(title: 'SupplierOrders')),
          leading: AppBeckButton(),
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
            tabs: [
              RepeatedTab(
                label: 'Preparing',
              ),
              RepeatedTab(
                label: 'shipping',
              ),
              RepeatedTab(label: 'Delivered')
            ],
          ),
        ),
        body: TabBarView(
          children: [PreparingOrders(), ShippingOrders(), DeliveredOrders()],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;

  const RepeatedTab({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
