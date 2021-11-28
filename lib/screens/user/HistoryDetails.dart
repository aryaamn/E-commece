import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/ScreanArguments.dart';
import 'package:cool_outfits/models/order.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:flutter/material.dart';

class HistoryDetails extends StatelessWidget {
  static String id = 'HistoryDetails';
  Store store = Store();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: store.loadOrdersDetails(args.documentId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data.docs) {
                products.add(Product(
                  pName: doc.data()[kProductName],
                  pQuantity: doc.data()[kProductQuantity],
                  pCategory: doc.data()[kProductCategory],
                  pPrice: doc.data()[kProductPrice],
                ));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .50,
                          color: kSecondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Product name: ${products[index].pName}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Quantity: ${products[index].pQuantity}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Product Category: ${products[index].pCategory}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Product Price: ${products[index].pPrice}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                args.image == null
                                    ? Text(
                                        'Kategori: COD',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Image.network(args.image,
                                        height: 150, fit: BoxFit.fill),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: products.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonTheme(
                              buttonColor: kMainColor,
                              child: RaisedButton(
                                onPressed: () {
                                  showCustomDialog(args, store, context);
                                },
                                // child: Text('Confirm Order'),
                              )),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ButtonTheme(
                              buttonColor: kMainColor,
                              child: RaisedButton(
                                onPressed: () {},
                                // child: Text('Delete Order'),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Loading Order Details'),
              );
            }
          }),
    );
  }

  void showCustomDialog(ScreenArguments orders, store, context) async {
    var price = orders.totalPrice; //getTotalPrice(orders.totalPrice);
    var address = orders.address; //getAddress(orders);
    AlertDialog alertDialog = AlertDialog(
        actions: [
          MaterialButton(
            child: Text('send order'),
            onPressed: () {
              try {
                store.updateOrders(orders.documentId);
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Ordered Successfully')));
                Navigator.pop(context);
              } catch (e) {
                print(e.message);
              }
            },
          )
        ],
        title: Text('Total Price = \Rp $price'
            '   address =\ $address'));
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Order> orders) {}
  getAddress(List<Order> orders) {}
}
