part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderSuccessState extends OrderState {}

class OrderLoadingDataState extends OrderState {}

class OrderSuccessDataState extends OrderState {}

class OrderFailureState extends OrderState {}

class UnAuthorizeState extends OrderState{}
