import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/functions.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/screens/login_screen.dart';
import 'package:cool_outfits/screens/user/HistoryOrder.dart';
import 'package:cool_outfits/screens/user/cartScreen.dart';
import 'package:cool_outfits/screens/user/productInfo.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:cool_outfits/widgets/productView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_outfits/services/auth.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'Delivery.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_FULLSCREEN);
  }

  final _auth = Auth();

  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _bottomBarIndex,
            onTap: (value) async {
              if (value == 2) {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                await _auth.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
              }
              setState(() {
                _bottomBarIndex = value;
              });
            },
            fixedColor: kMainColor,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'test'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'test'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.close), label: 'Sign out'),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: [
                  Text(
                    'Earphone',
                    style: TextStyle(
                        color:
                            _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 0 ? 16 : null),
                  ),
                  Text(
                    'Case',
                    style: TextStyle(
                        color:
                            _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 1 ? 16 : null),
                  ),
                  Text(
                    'Charger',
                    style: TextStyle(
                        color:
                            _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 2 ? 16 : null),
                  ),
                  Text(
                    'Tripod',
                    style: TextStyle(
                        color:
                            _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 3 ? 16 : null),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            jacketView(),
            productsView(kTshirts, _products),
            productsView(kTrousers, _products),
            productsView(kShoes, _products),
          ]),
        ),
      ),
      Material(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Authentic Cell Shop'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                    child: Icon(Icons.shopping_cart),
                    onTap: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    }),
                GestureDetector(
                    child: Icon(Icons.message),
                    onTap: () {
                      Navigator.pushNamed(context, Delivery.id);
                    }),
                GestureDetector(
                    child: Icon(Icons.history),
                    onTap: () {
                      Navigator.pushNamed(context, HistoryOrder.id);
                    }),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    secureScreen();
    getCurrentUser();
  }

  getCurrentUser() async {
    kGetUID = await _auth.getUserID();
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
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
          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .9),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[index]);
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    '\Rp ${products[index].pPrice} Stock: ${products[index].pQuantity}'),
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
    );
  }
}
