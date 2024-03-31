
class Product {
  late String name;
  late  double price;
  late dynamic qty;
  late dynamic qntty;
  late List imageUrl;
  late String documentId;
  late String suppId;

  Product(
      {required this.name,
        required this.price,
        required this.qty,
        required this.qntty,
        required this.imageUrl,
        required this.documentId,
        required this.suppId});

  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}
