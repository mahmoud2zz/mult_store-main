import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mult_store/providers/cart_providers.dart';
import 'package:mult_store/widget/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../minor_screens/place_oder.dart';
import '../model/cart_model.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';
import '../widget/appber_widgets.dart';
import '../widget/yellow_button.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;

  const CartScreen({super.key, this.back});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
   double total=  context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const AppBerTitle(
                title: 'Cart',
              ),
              leading: widget.back,
              actions: [
                context.watch<Cart>().getItems.isEmpty
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          MyAlertDilaog.showMyDialog(
                              context: context,
                              title: 'Clear Cart',
                              content: 'Are you sure clear cart?',
                              tabYes: () {
                                context.read<Cart>().clearCart();
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
            body: context.watch<Cart>().getItems.isEmpty
                ? const EmptyCart()
                : const CartItems(),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total:\$ ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        total.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width*0.45,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(25)

                    ),
                    child: MaterialButton(
                     onPressed:total==0.0?null:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaceOrderScreen()));
                     },

                      child: Text('CHECK OUT'),

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(25)),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.5,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Contiue Shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, index) {
              final Product product = cart.getItems[index];
              return CartModel(
                product: product,
                cart: context.read<Cart>(),
              );
            });
      },
    );
  }
}
