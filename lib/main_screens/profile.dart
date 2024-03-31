import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/widget/appber_widgets.dart';
import 'package:mult_store/widget/alert_dialog.dart';
import '../customer_screens/cart.dart';
import '../customer_screens/customer_order.dart';
import '../customer_screens/wilshlist_.dart';
import '../minor_screens/sub_categ_products.dart';
import '../widget/alert_dialog.dart';
import 'cart.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
   ProfileScreen({super.key, required this.documentId, });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    CollectionReference customers = FirebaseFirestore.instance.collection('customers');
    CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');


     return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymous.doc().get():customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          print('-----------');
          print(data['profileImage']);
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                    height: 230,
                    decoration: BoxDecoration(
                        gradient:
                        LinearGradient(colors: [Colors.yellow, Colors.brown]))),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      elevation: 0,
                      pinned: true,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            background: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.yellow, Colors.brown])),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 35, top: 20),
                                    child:    data['profileImage']=='' ?CircleAvatar(
                                      backgroundImage:
                                      AssetImage('images/inapp/guest.jpg'),
                                      radius: 50,
                                    ):CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(data['profileImage']),
                                      radius: 50,
                                    )

                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                   data['name']=='' ?'guest': data['name'].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            title: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: constraints.biggest.height <= 120 ? 1 : 0,
                              child: Text(
                                'Account',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.grey.shade300,
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      child: TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CartScreen(
                                                  back: AppBeckButton(),
                                                ))),
                                        child: Text(
                                          'Cart',
                                          style: TextStyle(
                                              color: Colors.yellow, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.only(),
                                    ),
                                    child: SizedBox(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      child: TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerOrder())),
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                              color: Colors.black54, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      child: TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WishListScreen())),
                                        child: Text(
                                          'Wishlist',
                                          style: TextStyle(
                                              color: Colors.yellow, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              child: Image.asset('images/inapp/logo.jpg'),
                            ),
                            ProfileHeaderLabel(headerLabel: ' Account Info. '),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      title: 'Email No',
                                      subtitle: data['email']==''?'example@email.com': data['email'],
                                      iconData: Icons.email,
                                    ),
                                    YellewDivider(),
                                    RepeatedListTile(
                                      title: 'Phone No',
                                      subtitle: data['phone']==''?'example:+1111111':data['phone'],
                                      iconData: Icons.phone,
                                    ),
                                    YellewDivider(),
                                    RepeatedListTile(
                                      title: ' Address',
                                      subtitle: data['address']==''?' New Gersy_usa':data['address'],
                                      iconData: Icons.location_pin,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ProfileHeaderLabel(headerLabel: '  Account Settings '),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      title: 'Email Address',
                                      iconData: Icons.edit,
                                      onTap: () {},
                                    ),
                                    YellewDivider(),
                                    RepeatedListTile(
                                      title: 'Change Password',
                                      iconData: Icons.lock,
                                      onTap: () {},
                                    ),
                                    YellewDivider(),
                                    RepeatedListTile(
                                      title: 'Log Out',
                                      iconData: Icons.logout,
                                      onTap: () async {
                                        MyAlertDilaog.showMyDialog(
                                            context: context,
                                            title: 'Log out',
                                            content: 'Are you sure to log out ?',
                                            tabYes: () async{   await FirebaseAuth.instance.signOut();
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                                context, '/welcome_screen');},
                                            tabNo: () {
                                              Navigator.pop(context);
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }

        return  Center(child: CircularProgressIndicator(color: Colors.purple,),);
      },

    );

  }
}



class YellewDivider extends StatelessWidget {
  const YellewDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final Function()? onTap;

  const RepeatedListTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const ProfileHeaderLabel({
    super.key,
    required this.headerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 60,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 60,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
