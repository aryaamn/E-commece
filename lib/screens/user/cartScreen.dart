import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/ScreanArguments.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/provider/cartItem.dart';
import 'package:cool_outfits/screens/user/payment.dart';
import 'package:cool_outfits/screens/user/productInfo.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:cool_outfits/widgets/customMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cool_outfits/services/auth.dart';

class CartScreen extends StatelessWidget {
  static String id = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            if (products.isNotEmpty) {
              return Container(
                height: screenHeight -
                    (screenHeight * 0.08) -
                    appBarHeight -
                    statusBarHeight,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTapUp: (details) {
                          showCustomMenu(details, context, products[index]);
                        },
                        child: Container(
                          height: screenHeight * .15,
                          color: kSecondaryColor,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: screenHeight * .15 / 2,
                                backgroundImage:
                                    AssetImage(products[index].pLocation),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            products[index].pName,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '\Rp${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        products[index].pQuantity.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );
            } else {
              return Container(
                height: screenHeight -
                    (screenHeight * 0.08) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            }
          }),
          Builder(
            builder: (context) => ButtonTheme(
              minWidth: screenWidth,
              height: screenHeight * .08,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )),
                child: Text(
                  'Order'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: kMainColor,
                onPressed: () {
                  showCustomDialog(products, context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product) async {
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
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
          ),
          MyPopupMenuItem(
            child: Text('Delete'),
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
            },
          ),
        ]);
  }

  void showCustomDialog(List<Product> products, context) async {
    final _auth = Auth();
    final user = await _auth.getUserID();
    var price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        MaterialButton(
          child: Text('Chose Your payment'),
          onPressed: () {
            try {
              Navigator.pop(context);
              showPaymentDialog(context, price, address, 'P', user, products);
            } catch (e) {
              print(e.message);
            }
          },
        )
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter your address'),
      ),
      title: Text('Total Price = \Rp $price'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += product.pQuantity * int.parse(product.pPrice);
    }
    return price;
  }
}

getStock(List<Product> products) {}

void showPaymentDialog(
    context, price, address, status, user, List<Product> products) async {
  AlertDialog alertDialog = AlertDialog(
    actions: [
      MaterialButton(
        child: Text('Bank'),
        onPressed: () {
          Navigator.popAndPushNamed(context, payment.id,
              arguments:
                  ScreenArguments(price, address, null, status, user, 'image'));
        },
      ),
      MaterialButton(
          child: Text('COD'),
          onPressed: () async {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Ordered Successfully')));
            Navigator.pop(context);
            Store _store = Store();
            _store.storeOrders({
              kTotalPrice: price,
              kAddress: address,
              kStatus: 'P',
              kUserId: user,
            }, products);
            for (var doc in products) {
              DocumentSnapshot data = await _store.loadProductsId(doc.pId);
              int min = 0;
              min = data['pQuantity'] - doc.pQuantity;
              _store.minProductsId(doc.pId, min);
            }
          })
    ],
    // content: TextField(),
    title: Text('Chose Your payment'),
  );
  await showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      });
}
