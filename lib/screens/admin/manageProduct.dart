import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/screens/admin/editProduct.dart';
import 'package:cool_outfits/widgets/customMenu.dart';
import 'package:flutter/material.dart';
import 'package:cool_outfits/services/store.dart';

class ManageProducts extends StatefulWidget {
  static String id = 'ManageProducts.id';

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              var data = doc.data();

              products.add(Product(
                  // ignore: deprecated_member_use
                  pId: doc.documentID,
                  pName: data[kProductName],
                  pPrice: data[kProductPrice],
                  pLocation: data[kProductLocation],
                  pDescription: data[kProductDescription],
                  pCategory: data[kProductCategory],
                  pQuantity: data[kpQuantity]));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .9),
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTapUp: (details) {
                    double dx = details.globalPosition.dx;
                    double dy = details.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width - dx;
                    double dy2 = MediaQuery.of(context).size.width - dy;
                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                        items: [
                          MyPopupMenuItem(
                            child: Text('Edit'),
                            onClick: () {
                              Navigator.pushNamed(context, EditProduct.id,
                                  arguments: products[index]);
                            },
                          ),
                          MyPopupMenuItem(
                            child: Text('Delete'),
                            onClick: () {
                              _store.deleteProduct(products[index].pId);
                              Navigator.pop(context);
                            },
                          ),
                        ]);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          products[index].pLocation,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: .6,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index].pName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('\$ ${products[index].pPrice}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              itemCount: products.length,
            );
          } else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}
