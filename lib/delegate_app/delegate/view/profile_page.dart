import 'package:delivery_app/delegate_app/delegate/bloc/create_delegate_bloc.dart';
import 'package:delivery_app/delegate_app/delegate/repository/delegate_repository.dart';
import 'package:delivery_app/delegate_app/delegate/view/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.delegateRepository});

  final DelegateRepository delegateRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: delegateRepository,
      child: BlocProvider(
        create: (context) => CreateDelegateBloc(delegateRepository),
        child: const ProfileView(),
      ),
    );
  }
}
