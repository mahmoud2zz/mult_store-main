import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mult_store/providers/cart_providers.dart';
import 'package:mult_store/providers/wish_provider.dart';
import 'package:mult_store/widget/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../model/wish_model.dart';
import '../providers/product_class.dart';
import '../widget/appber_widgets.dart';
import '../widget/yellow_button.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreen();
}

class _WishListScreen extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              leading: AppBeckButton(),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const AppBerTitle(
                title: 'WishList',
              ),
              actions: [
                context.watch<Cart>().getItems.isEmpty
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          MyAlertDilaog.showMyDialog(
                              context: context,
                              title: 'Clear Wich',
                              content: 'Are you sure clear cart?',
                              tabYes: () {
                                context.read<Wish>().clearWishlist();
                                Navigator.pop(context);
                              },
                              tabNo: () {
                                print('-------');
                                Navigator.pop(context);
                              });
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ))
              ],
            ),
            body: context.watch<Wish>().getWishItems.isEmpty
                ? EmptyWishList()
                : WishItems(),
          ),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final Product product = wish.getWishItems[index];
              return WishListModel(product: product);
            });
      },
    );
  }
}

