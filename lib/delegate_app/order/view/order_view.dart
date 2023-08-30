import 'package:delivery_app/delegate_app/delegate/repository/delegate_repository.dart';
import 'package:delivery_app/delegate_app/delegate/view/create_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/core.dart';
import '../bloc/order_bloc.dart';
import '../widget/widget.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

late TabController tabcontroller;

class _OrderViewState extends State<OrderView> with TickerProviderStateMixin {
  late final OrderBloc bloc;

  @override
  void initState() {
    bloc = context.read<OrderBloc>();
    tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        tabs: [
          Tab(text: trans(context).newOrder),
          Tab(text: trans(context).acceptedOrder)
        ],
        controller: tabcontroller,
      ),
      body: OfflineWidget(
        child: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderSuccessState ||
                  state is OrderLoadingDataState ||
                  state is OrderLoadingState) {
                if (!bloc.delegate.active && bloc.delegate.acceptable) {
                  return EmptyData(
                      assetIcon: iServerDown,
                      title: trans(context).disabledAccount);
                } else if (!bloc.delegate.acceptable) {
                  return EmptyData(
                      assetIcon: iServerDown,
                      title: trans(context).yourAccountNotApproved);
                }
                return TabBarView(
                  controller: tabcontroller,
                  children: [
                    NewOrders(
                      orders: bloc.orders,
                    ),
                    AcceptedOrder(
                      orders: bloc.orders,
                    ),
                  ],
                );
              } else if (state is UnAuthorizeState) {
                return const _UnDocumentedWidget();
              }
              return EmptyData(
                assetIcon: iEmpty,
                title: trans(context).noNewOrder,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _BottomBarWidget(bloc: bloc),
    );
  }
}

class _UnDocumentedWidget extends StatelessWidget {
  const _UnDocumentedWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyData(
          assetIcon: iServerDown,
          title: trans(context).unDocumented,
        ),
        vSpace(3),
        LandkBtn(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateDelegatePage(
                  delegateRepository: DelegateRepository(),
                ),
              ),
            );
          },
          title: Text(trans(context).verifyAccount),
          width: 80,
          height: 7,
        )
      ],
    );
  }
}

class _BottomBarWidget extends StatelessWidget {
  const _BottomBarWidget({
    required this.bloc,
  });

  final OrderBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.3.h),
            child: Text(
              trans(context).offline,
              style: h4,
            ),
          ),
        ),
        BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState) {
              return SizedBox(height: 5.h, child: loadingWidget());
            }
            return CupertinoSwitch(
              value: _handleDelegateState(),
              onChanged: (value) {
                if (_checkIsDelegateAcceptable()) {
                  bloc.add(ToggleDelegateState(state: value));
                }
              },
              activeColor: orange,
            );
          },
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.3.h),
            child: Text(
              trans(context).online,
              style: h4,
            ),
          ),
        ),
      ],
    );
  }

  bool _checkIsDelegateAcceptable() {
    return bloc.state is! UnAuthorizeState &&
        bloc.delegate.acceptable &&
        bloc.delegate.active;
  }

  bool _handleDelegateState() {
    return bloc.state is UnAuthorizeState
        ? false
        : !bloc.delegate.acceptable
            ? false
            : !bloc.delegate.active
                ? false
                : bloc.delegate.available;
  }
}
