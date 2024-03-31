import 'package:flutter/cupertino.dart';
import 'package:mult_store/providers/product_class.dart';


class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems => _list;

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.qty;
    }

    return total;
  }

  int get count => _list.length;

  void addItems(String nameee, double price, dynamic qty, dynamic qntty, List imageUrl,
      String documentId, String suppId) {
    Product product = Product(
        name: nameee,
        price: price,
        qty: qty,
        qntty: qntty,
        imageUrl: imageUrl,
        documentId: documentId,
        suppId: suppId);
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
