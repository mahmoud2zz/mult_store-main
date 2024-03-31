import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/main_screens/visit_store.dart';

import '../dashboard_compontes/edite_business.dart';
import '../dashboard_compontes/manage_products.dart';
import '../dashboard_compontes/my_store.dart';
import '../dashboard_compontes/supp_balance.dart';
import '../dashboard_compontes/supp_order.dart';
import '../dashboard_compontes/supp_statics.dart';
import '../widget/alert_dialog.dart';
import '../widget/appber_widgets.dart';

List<String> label = [
  'my stores',
  'orders',
  'edite profile',
  'manage products',
  'balance',
  'statics'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  SupplierOrder(),
  EditeBusiness(),
  ManageProducts(),
  SupplierBalance(),
  SupplierStatic()
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBerTitle(
          title: 'Dashpoard',
        ),
        actions: [
          IconButton(
              onPressed: () {
                MyAlertDilaog.showMyDialog(
                    context: context,
                    title: 'Log out',
                    content: 'Are you sure to log out ?',
                    tabYes: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, '/welcome_screen');
                    },
                    tabNo: () {
                      Navigator.pop(context);
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 50,
          mainAxisSpacing: 50,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pages[index])),
              child: Card(
                elevation: 20,
                shadowColor: Colors.pinkAccent.shade200,
                color: Colors.blueGrey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      color: Colors.yellow,
                      size: 50,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          fontFamily: 'Acme'),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
