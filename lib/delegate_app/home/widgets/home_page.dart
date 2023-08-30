import 'package:delivery_app/delegate_app/order/repository/order_repository.dart';
import 'package:flutter/material.dart';

import '../../order/order.dart';

class HomePage extends StatefulWidget {
  static Page page() => const MaterialPage(child: HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return OrderPage(orderRepository: OrderRepository());
  }
}
