import 'package:cool_outfits/models/order.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier {
  List<Product> products = [];
  List<Order> orders = [];

  addOrder(Order orders) {
    orders.add(orders);
    notifyListeners();
  }

  addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
