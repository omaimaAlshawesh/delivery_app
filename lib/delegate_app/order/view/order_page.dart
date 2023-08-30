import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/order_bloc.dart';
import '../repository/order_repository.dart';
import 'order_view.dart';

class OrderPage extends StatelessWidget {
  static Page page() => MaterialPage(
          child: OrderPage(
        orderRepository: OrderRepository(),
      ));
  const OrderPage({super.key, required this.orderRepository});

  final OrderRepository orderRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: orderRepository,
      child: BlocProvider(
        create: (context) => OrderBloc(orderRepository),
        child: const OrderView(),
      ),
    );
  }
}
