import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:cool_outfits/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  String _name, _price, _description, _category, _imageLocation, _qty;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  Future<void> saveData(_name, _price, _description, _category, _imageLocation,
      _qty, product) async {
    DocumentSnapshot data = await _store.loadProductsId(product.pId);
    if (_name == '') {
      _name = data[kProductName];
    }
    if (_price == '') {
      _price = data[kProductPrice];
    }
    if (_imageLocation == '') {
      _imageLocation = data['productLocation'];
    }
    if (_description == '') {
      _description = data[kProductDescription];
    }
    if (_category == '') {
      _category = data[kProductCategory];
    }
    if (_qty == '') {
      _qty = data['pQuantity'];
    } else {
      _qty = data['pQuantity'] + int.parse(_qty);
    }
    _store.editProduct(
        ({
          kProductName: _name,
          kProductLocation: _imageLocation,
          kProductCategory: _category,
          kProductDescription: _description,
          kProductPrice: _price,
          kpQuantity: _qty
        }),
        product.pId);
  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .2),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  hint: 'Product Name',
                  onClick: (value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: 'Product Price',
                  onClick: (value) {
                    _price = value;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: 'Product Description',
                  onClick: (value) {
                    _description = value;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: 'Product Category',
                  onClick: (value) {
                    _category = value;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: 'Product Location',
                  onClick: (value) {
                    _imageLocation = value;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hint: 'Qty Product',
                  onClick: (value) {
                    _qty = value;
                  },
                ),
                RaisedButton(
                  child: Text('Edit Product'),
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
                      saveData(_name, _price, _description, _category,
                          _imageLocation, _qty, product);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
