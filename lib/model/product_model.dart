import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mult_store/minor_screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/wish_provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;

  const ProductModel({
    super.key,
    required this.products,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      proList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: 250,
                  ),
                  child: Image.network(widget.products['proImages'][0]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.products['proName'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.products['price'].toStringAsFixed(2) +
                                ('\$'),
                            style: TextStyle(color: Colors.red),
                          ),
                          widget.products['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                  color: Colors.red,
                                )
                              : IconButton(
                                  onPressed: () {
                                    var existingItemWishList=     context
                                        .read<Wish>()
                                        .getWishItems
                                        .firstWhereOrNull((product) =>
                                    product.documentId ==
                                        widget.products['proId']);
                                    existingItemWishList!=
                                            null
                                        ? context.read<Wish>().removeThisItem(
                                            widget.products['proId'])
                                        : context.read<Wish>().addWishItems(
                                            widget.products['proName'],
                                            widget.products['price'],
                                            1,
                                            widget.products['instock'],
                                            widget.products['proImages'],
                                            widget.products['proId'],
                                            widget.products['sid']);
                                  },
                                  icon: context
                                              .watch<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget.products['proId']) !=
                                          null
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.red,
                                        ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
