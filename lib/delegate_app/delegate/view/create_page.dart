import 'package:delivery_app/delegate_app/delegate/bloc/create_delegate_bloc.dart';
import 'package:delivery_app/delegate_app/delegate/view/create_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/delegate_repository.dart';

class CreateDelegatePage extends StatelessWidget {
  const CreateDelegatePage({super.key, required this.delegateRepository});

  final DelegateRepository delegateRepository;

  static Page page() => MaterialPage(
          child: CreateDelegatePage(
        delegateRepository: DelegateRepository(),
      ));

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: DelegateRepository(),
      child: BlocProvider(
        create: (context) => CreateDelegateBloc(delegateRepository),
        child: const CreateDelegateView(),
      ),
    );
  }
}
