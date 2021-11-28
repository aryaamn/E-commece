import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/order.dart';
import 'package:cool_outfits/services/store.dart';
import 'package:flutter/material.dart';

class Delivery extends StatelessWidget {
  static String id = 'Delivery';
  final Store _store = Store();

  @override
  Widget build(BuildContext context) {
    // CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrdersByID(kGetUID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('There is no orders'),
            );
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.docs) {
              orders.add(Order(
                totalPrice: doc.data()[kTotalPrice],
                address: doc.data()[kAddress],
                status: doc.data()[kStatus],
                // ignore: deprecated_member_use
                documentId: doc.documentID,
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    color: kSecondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Order ID # ${orders[index].documentId}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          orders[index].status == "P"
                              ? Text(
                                  'Status On proses',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Status Delivery',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}
