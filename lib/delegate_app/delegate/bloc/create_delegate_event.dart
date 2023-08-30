// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_delegate_bloc.dart';

sealed class CreateDelegateEvent extends Equatable {
  const CreateDelegateEvent();

  @override
  List<Object> get props => [];
}

class _FetchDelegate extends CreateDelegateEvent {
  final Delegate delegate;
  const _FetchDelegate({
    required this.delegate,
  });
}

class UpdateDelegate extends CreateDelegateEvent {}

class DeleteDelegate extends CreateDelegateEvent {
  final String id;
  const DeleteDelegate({
    required this.id,
  });
}

class CreateDelegate extends CreateDelegateEvent {}
