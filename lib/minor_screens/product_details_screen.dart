import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:mult_store/customer_screens/cart.dart';
import 'package:mult_store/minor_screens/full_screen_view.dart';
import 'package:mult_store/main_screens/visit_store.dart';
import 'package:mult_store/providers/product_class.dart';
import 'package:mult_store/providers/wish_provider.dart';
import 'package:mult_store/widget/appber_widgets.dart';
import 'package:mult_store/widget/sankbar.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import '../model/product_model.dart';
import '../providers/cart_providers.dart';
import '../widget/yellow_button.dart';
import '../main_screens/cart.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;

  ProductDetailsScreen({super.key, required this.proList});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('mainCate', isEqualTo: widget.proList['mainCate'])
      .where('subCate', isEqualTo: widget.proList['subCate'])
      .snapshots();

  Product? existingItemCart;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (element) => widget.proList['proId'] == element.documentId);

    List<dynamic> imagesList = widget.proList['proImages'];
    print(existingItemCart);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreenView(
                                images: imagesList,
                              )));
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (BuildContext context, int index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                                fit: BoxFit.cover,
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        Positioned(
                            left: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        Positioned(
                            right: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.proList['proName'],
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'USD ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.proList['price'].toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    var existingItemWishList = context
                                        .read<Wish>()
                                        .getWishItems
                                        .firstWhereOrNull((product) =>
                                            product.documentId ==
                                            widget.proList['proId']);
                                    existingItemWishList != null
                                        ? context
                                            .read<Cart>()
                                            .removeItem(widget.proList['proId'])
                                        : context.read<Wish>().addWishItems(
                                            widget.proList['proName'],
                                            widget.proList['price'],
                                            1,
                                            widget.proList['instock'],
                                            widget.proList['proImages'],
                                            widget.proList['proId'],
                                            widget.proList['sid']);
                                  },
                                  icon: context
                                              .watch<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget.proList['proId']) !=
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
                          ),
                          widget.proList['instock'] <=0
                              ? Text(
                                  'The item is out of stock',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  (widget.proList['instock'].toString()) +
                                      (' pieces availbale in  stock')
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                          ProductDetailsHeader(
                            label: ' Item Descriprtion',
                          ),
                          Text(
                            widget.proList['proDesc'],
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          ProductDetailsHeader(
                            label: ' Similar Item',
                          ),
                          SizedBox(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _productStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'this category  has \n \n items yet !',
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Acme',
                                            letterSpacing: 1.5),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  return SingleChildScrollView(
                                    child: StaggeredGridView.countBuilder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.size,
                                      crossAxisCount: 2,
                                      itemBuilder: (context, int index) {
                                        return ProductModel(
                                          products: snapshot.data!.docs[index],
                                        );
                                      },
                                      staggeredTileBuilder: (context) =>
                                          StaggeredTile.fit(1),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomSheet: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitStore(
                                      suppId: widget.proList['sid'])));
                        },
                        icon: Icon(Icons.store)),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CartScreen(back: AppBeckButton()))),
                        icon: badges.Badge(
                          showBadge: context.read<Cart>().getItems.isNotEmpty
                              ? true
                              : false,
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.yellow),
                          badgeContent: Text(
                            context.watch<Cart>().getItems.length.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          child: Icon(Icons.shopping_cart),
                        )),
                    YellowButton(
                      label: existingItemCart != null
                          ? 'added to cart'
                          : 'ADD TO CART',
                      onPressed: () {
                        if (widget.proList['instock'] == 0) {
                          MyMessagesHandler.showSankBar(
                              _scaffoldKey, 'this item out of stock');
                        } else if (existingItemCart != null) {
                          MyMessagesHandler.showSankBar(_scaffoldKey,
                              'this item alreay in cart your cart');
                        } else {
                          context.read<Cart>().addItems(
                              widget.proList['proName'],
                              widget.proList['price'],
                              1,
                              widget.proList['instock'],
                              widget.proList['proImages'],
                              widget.proList['proId'],
                              widget.proList['sid']);
                        }
                      },
                      width: 0.5,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  final String label;

  const ProductDetailsHeader({
    super.key,
    required this.label,
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
            label,
            style: TextStyle(
                color: Colors.yellow.shade600,
                fontSize: 24,
                fontWeight: FontWeight.w600),
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
