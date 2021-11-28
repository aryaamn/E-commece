import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_outfits/constants.dart';
import 'package:cool_outfits/models/product.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollections).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductLocation: product.pLocation,
      kpQuantity: product.pQuantity,
    });
  }

  Stream<QuerySnapshot> loadProducts() {
    return _firestore
        .collection(kProductsCollections)
        .where("pQuantity", isGreaterThan: 0)
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore
        .collection(kOrders)
        .where('status', isEqualTo: 'P')
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrdersByID(userid) {
    return _firestore
        .collection(kOrders)
        .where('userid', isEqualTo: userid)
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrdersDetails(documentId) {
    return _firestore
        .collection(kOrders)
        .doc(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(documentId) {
    _firestore.collection(kProductsCollections).doc(documentId).delete();
  }

  editProduct(data, documentId) {
    _firestore.collection(kProductsCollections).doc(documentId).update(data);
  }

  loadProductsId(documentId) {
    return _firestore.collection(kProductsCollections).doc(documentId).get();
  }

  minProductsId(documentId, min) {
    _firestore
        .collection(kProductsCollections)
        .doc(documentId)
        .update({'pQuantity': min});
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _firestore.collection(kOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory,
      });
    }
  }

  updateOrders(documentId) {
    _firestore.collection(kOrders).doc(documentId).update({"status": "D"});
  }
}
