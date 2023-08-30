import 'package:delivery_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constances/media_const.dart';
import '../../../core/shared/shared.dart';
import '../bloc/order_bloc.dart';
import '../repository/order_repository.dart';
import 'order_item.dart';

class NewOrders extends StatefulWidget {
  const NewOrders({super.key, required this.orders});

  final List<Order> orders;

  @override
  State<NewOrders> createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  late final OrderBloc bloc;
  late final List<Order> orders;

  @override
  void initState() {
    bloc = context.read<OrderBloc>();
    orders = widget.orders
        .where(
            (element) => element.acceptable == true && element.delegate.isEmpty)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orders.isNotEmpty
        ? ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderItem(order: order);
            },
          )
        : EmptyData(
            assetIcon: iEmpty,
            title: trans(context).noNewOrder,
          );
  }
}
