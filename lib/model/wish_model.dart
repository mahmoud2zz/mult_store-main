import 'package:flutter/cupertino.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_providers.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';

class WishListModel extends StatelessWidget {
  const WishListModel({
    super.key,
    required this.product,
  });

  final Product product;

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
                child: Image.network(product.imageUrl.first),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(3.0),
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.read<Wish>().removeItem(product),
                              icon: Icon(
                                Icons.delete_forever,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            context.read<Cart>().getItems.firstWhereOrNull(
                                        (element) =>
                                            element.documentId ==
                                            product.documentId) !=
                                    null|| product.qntty==0
                                ? SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItems(
                                          product.documentId,
                                          product.price,
                                          1,
                                          product.qntty,
                                          product.imageUrl,
                                          product.documentId,
                                          product.suppId);
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart,
                                    ),
                                  ),
                          ],
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
