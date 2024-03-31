import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/cart_providers.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product, required this.cart,
  });

  final Product product;
  final Cart cart;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(product.imageUrl[0]),
              ),
              Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.price.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  product.qty == 1
                                      ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                                title: const Text('Remove Item'),
                                                message: const Text(
                                                    'Are you sure remove Item'),
                                                actions: <CupertinoActionSheetAction>[
                                                  CupertinoActionSheetAction(
                                                    /// This parameter indicates the action would be a default
                                                    /// default behavior, turns the action's text to bold text.
                                                    isDefaultAction: true,
                                                    onPressed: () async {
                                                      context
                                                          .read<Wish>()
                                                          .getWishItems
                                                          .firstWhereOrNull(
                                                              (element) =>
                                                          element
                                                              .documentId ==
                                                              product) !=
                                                          null
                                                          ? context
                                                          .read<Cart>()
                                                          .removeItem(product)
                                                          : context
                                                          .read<Wish>()
                                                          .addWishItems(
                                                          product.name,
                                                          product.price,
                                                          1,
                                                          product.qntty,
                                                          product.imageUrl,
                                                          product
                                                              .documentId,
                                                          product.suppId);
                                                      context
                                                          .read<Cart>()
                                                          .removeItem(product);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        'Move to WishLest'),
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      context
                                                          .read<Cart>()
                                                          .removeItem(product);
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                    const Text('Delete Item'),
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    /// This parameter indicates the action would perform
                                                    /// a destructive action such as delete or exit and turns
                                                    /// the action's text color to red.
                                                    isDestructiveAction: true,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        'Destructive Action'),
                                                  ),
                                                ],
                                                cancelButton: TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 16,
                                      ))
                                      : IconButton(
                                      onPressed: () {
                                      cart.reduceByOne(product);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.minus,
                                        size: 18,
                                      )),
                                  Text(
                                    product.qty.toString(),
                                    style: product.qty == product.qntty
                                        ? TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontFamily: 'Acme')
                                        : const TextStyle(
                                        fontSize: 20, fontFamily: 'Acme'),
                                  ),
                                  IconButton(
                                      onPressed: product.qty == product.qntty
                                          ? null
                                          : () {
                                        cart.increment(product);
                                      },
                                      icon: const Icon(FontAwesomeIcons.plus,
                                          size: 18)),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
