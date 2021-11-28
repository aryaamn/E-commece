import 'package:cool_outfits/models/product.dart';
import 'package:cool_outfits/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cool_outfits/services/store.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  String _name, _price, _description, _category, _imageLocation, _qty;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: Column(
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
              hint: 'Product Qty',
              onClick: (value) {
                _qty = value;
              },
            ),
            RaisedButton(
              child: Text('Add Product'),
              onPressed: () {
                if (_globalKey.currentState.validate()) {
                  _globalKey.currentState.save();
                  _store.addProduct(Product(
                      pName: _name,
                      pPrice: _price,
                      pCategory: _category,
                      pDescription: _description,
                      pLocation: _imageLocation,
                      pQuantity: int.parse(_qty)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
