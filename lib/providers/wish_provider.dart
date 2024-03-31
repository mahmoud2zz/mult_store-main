import 'package:flutter/cupertino.dart';
import 'package:mult_store/providers/product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishItems => _list;

  int get count => _list.length;

  Future<void> addWishItems(String name, double price, int qty, int qntty,
      List imageUrl, String documentId, String suppId) async {
    Product product = Product(
        name: name,
        price: price,
        qty: qty,
        qntty: qntty,
        imageUrl: imageUrl,
        documentId: documentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void removeThisItem(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }
}
