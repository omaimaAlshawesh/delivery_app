// ignore: library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as fStore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import '../../../../models/model.dart';
import 'models/model.dart';

abstract class _OrderRepository {
  Future<void> acceptOrder(String id);
  Future<Order> fetchOneOrder(String id);
  Future<Customer> fetchCustomer(String id);
  Future<void> makeDelivered(String id);
  Future<List<Product>> fetchAllProducts(List<String> ids);
  Stream<List<Order>> fetchAllOrder();
}

class OrderRepository implements _OrderRepository {
  final fStore.FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  OrderRepository()
      : _firestore = fStore.FirebaseFirestore.instance,
        _auth = FirebaseAuth.instance;

  @override
  Future<void> acceptOrder(String id) async {
    try {
      await _firestore.collection('orders').doc(id).update({
        'delegate': _auth.currentUser!.uid,
      }).then((_) {
        Location.instance.onLocationChanged.listen((event) async {
          await _firestore
              .collection('delegates')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'location': {
              'latitude': event.latitude,
              'longitude': event.longitude,
              'specialMarque': ''
            },
          });
        });
      });
    } catch (e) {
      print('acceptOrder: $e');
    }
  }

  @override
  Stream<List<Order>> fetchAllOrder() {
    try {
      return _firestore.collection('orders').snapshots().map((event) {
        return List<Order>.from(event.docs.map((e) => Order.fromMap(e.data())));
      });
    } catch (e) {
      return Stream.error(e);
    }
  }

  @override
  Future<Customer> fetchCustomer(String id) async {
    try {
      return Customer.fromMap(
          (await _firestore.collection('customers').doc(id).get()).data()!);
    } catch (e) {
      print('fetchCustomer: $e');
      return Customer.empty();
    }
  }

  @override
  Future<Order> fetchOneOrder(String id) async {
    try {
      return Order.fromMap((await _firestore
              .collection('stores')
              .doc(_auth.currentUser!.uid)
              .collection('orders')
              .doc(id)
              .get())
          .data()!);
    } catch (e) {
      print('fetchOneOrder: $e');
      return Order.empty();
    }
  }

  @override
  Future<List<Product>> fetchAllProducts(List<String> ids) async {
    List<Product> products = [];
    try {
      // for (var element in ids) {
      await _firestore
          .collection('products')
          .where('id', whereIn: ids)
          .get()
          .then((value) {
        products = List<Product>.from(
            value.docs.map((e) => Product.fromMap(e.data())));
        // value.docs.map((e) {});
      });
      // }
      return products;
    } catch (e) {
      print('fetchAllProducts: $e');
      return [];
    }
  }

  @override
  Future<void> makeDelivered(String id) async {
    try {
      await _firestore.collection('orders').doc(id).update({'delivered': true});
    } catch (e) {
      print('makeDelivered: $e');
    }
  }
}
