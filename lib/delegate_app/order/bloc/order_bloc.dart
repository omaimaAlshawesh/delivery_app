import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/delegate_app/delegate/repository/delegate_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/model.dart';
import '../repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(
    this._orderRepository,
  ) : super(OrderInitial()) {
    _delegateRepository = DelegateRepository();
    on<_FetchAllOrders>(_fetchAllOrder);
    on<FetchCustomer>(_fetchCustomer);
    on<FetchOneOrder>(_fetchOneOrder);
    on<FetchProduct>(_fetchProduct);
    on<AcceptOrder>(_acceptOrder);
    on<MakeDelivered>(_makeDelivered);
    on<CheckAuthorize>(_checkAuthorize);
    on<ToggleDelegateState>(_toggleDelegateState);

    _subscriptionDelegate = _delegateRepository
        .fetchDelegate(FirebaseAuth.instance.currentUser!.uid)
        .listen((event) {
      delegate = event;
      add(CheckAuthorize());
    });
  }

  final OrderRepository _orderRepository;
  StreamSubscription<List<Order>>? _subscription;
  StreamSubscription<Delegate>? _subscriptionDelegate;
  late final DelegateRepository _delegateRepository;
  List<Order> orders = [];

  Order order = Order.empty();
  Customer customer = Customer.empty();
  List<Product> products = [];
  Delegate delegate = Delegate.empty();

  @override
  Future<void> close() {
    if (_subscription != null && _subscriptionDelegate != null) {
      _subscription!.cancel();
      _subscriptionDelegate!.cancel();
    }
    return super.close();
  }

  FutureOr<void> _fetchAllOrder(_FetchAllOrders event, emit) {
    emit(OrderLoadingState());
    orders = event.orders;
    if (orders.isNotEmpty) {
      emit(OrderSuccessState());
    }
  }

  FutureOr<void> _makeDelivered(MakeDelivered event, emit) async {
    emit(OrderLoadingState());
    await _orderRepository
        .makeDelivered(event.id)
        .then((value) => emit(OrderSuccessState()));
  }

  FutureOr<void> _fetchCustomer(FetchCustomer event, emit) async {
    emit(OrderLoadingState());
    customer = await _orderRepository.fetchCustomer(event.id);
    emit(OrderSuccessState());
  }

  FutureOr<void> _fetchOneOrder(FetchOneOrder event, emit) async {
    emit(OrderLoadingState());
    order = await _orderRepository.fetchOneOrder(event.id);
    emit(OrderSuccessState());
  }

  FutureOr<void> _fetchProduct(FetchProduct event, emit) async {
    emit(OrderLoadingState());
    products = await _orderRepository.fetchAllProducts(event.ids);
    if (products.isNotEmpty) {
      emit(OrderSuccessState());
    }
  }

  FutureOr<void> _acceptOrder(AcceptOrder event, emit) async {
    emit(OrderLoadingState());
    await _orderRepository.acceptOrder(event.id);
    emit(OrderSuccessState());
  }

  FutureOr<void> _toggleDelegateState(ToggleDelegateState event, emit) async {
    if (delegate != Delegate.empty()) {
      emit(OrderLoadingState());
      await _delegateRepository
          .updateDelegate(delegate.copyWith(available: event.state))
          .then((value) {
        emit(OrderSuccessState());
      });
    }
  }

  FutureOr<void> _checkAuthorize(event, emit) {
    emit(OrderLoadingState());
    if (delegate == Delegate.empty()) {
      emit(UnAuthorizeState());
    } else {
      if (_subscription != null) {
        _subscription!.cancel();
      }
      _subscription = _orderRepository.fetchAllOrder().listen((event) {
        add(_FetchAllOrders(orders: event));
      });
    }
  }
}
