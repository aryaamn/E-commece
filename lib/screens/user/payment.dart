import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/ScreanArguments.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/provider/cartItem.dart';
import 'package:cool_outfits/screens/user/Delivery.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class payment extends StatefulWidget {
  static String id = 'payment';
  final ImagePicker _picker = ImagePicker();

  @override
  _paymentState createState() => _paymentState();
}

class _paymentState extends State {
  File _image;

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future updatePhoto(File imageFile, products, args, _store) async {
    String fileName = basename(imageFile.path);
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref =
        storage.ref().child('user/profile/$fileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    String url;
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();

      _store.storeOrders({
        kTotalPrice: args.totalPrice,
        kAddress: args.address,
        kStatus: args.status,
        kUserId: args.userid,
        kImage: url.toString()
      }, products);
      for (var doc in products) {
        DocumentSnapshot data = await _store.loadProductsId(doc.pId);
        int min = 0;
        min = data['pQuantity'] - doc.pQuantity;
        _store.minProductsId(doc.pId, min);
      }
      print(url.toString());
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  String msg =
      '\n\nTranfer ATM BRI : \nNO rek : 097364732946\natas nama : Arya mahardika';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    List<Product> products = Provider.of<CartItem>(context).products;
    Store _store = Store();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Transfer Bank'),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  msg,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                _image == null ? Text("Kirim Gambar") : Image.file(_image),
                RaisedButton(
                    child: Text('Upload'),
                    onPressed: () {
                      updatePhoto(_image, products, args, _store);
                      Navigator.pushNamed(context, Delivery.id);
                    })
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Increment',
          child: Icon(Icons.camera_alt),
        ));
  }
}
