import 'package:cool_outfits/screens/user/Delivery.dart';
import 'package:cool_outfits/screens/user/HistoryDetails.dart';
import 'package:cool_outfits/screens/user/HistoryOrder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/provider/adminMode.dart';
import 'package:cool_outfits/provider/cartItem.dart';
import 'package:cool_outfits/provider/modalHud.dart';
import 'package:cool_outfits/screens/admin/addProduct.dart';
import 'package:cool_outfits/screens/admin/adminPage.dart';
import 'package:cool_outfits/screens/admin/editProduct.dart';
import 'package:cool_outfits/screens/admin/manageProduct.dart';
import 'package:cool_outfits/screens/admin/orderDetails.dart';
import 'package:cool_outfits/screens/admin/viewOrders.dart';
import 'package:cool_outfits/screens/login_screen.dart';
import 'package:cool_outfits/screens/signup_screen.dart';
import 'package:cool_outfits/screens/user/cartScreen.dart';
import 'package:cool_outfits/screens/user/homePage.dart';
import 'package:cool_outfits/screens/user/payment.dart';
import 'package:cool_outfits/screens/user/productInfo.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            ),
          );
        } else {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? HomePage.id : LoginScreen.id,
              routes: {
                ManageProducts.id: (context) => ManageProducts(),
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomePage.id: (context) => HomePage(),
                AdminPage.id: (context) => AdminPage(),
                AddProduct.id: (context) => AddProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartScreen.id: (context) => CartScreen(),
                payment.id: (context) => payment(),
                ViewOrders.id: (context) => ViewOrders(),
                OrderDetails.id: (context) => OrderDetails(),
                Delivery.id: (context) => Delivery(),
                HistoryOrder.id: (context) => HistoryOrder(),
                HistoryDetails.id: (context) => HistoryDetails(),
              },
            ),
          );
        }
      },
    );
  }
}
