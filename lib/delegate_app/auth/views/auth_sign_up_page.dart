import 'package:delivery_app/delegate_app/auth/views/auth_sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/tools/tools_widget.dart';
import '../cubit/auth_cubit.dart';
import '../repository/authentication_repository.dart';

class AuthSignUpPage extends StatelessWidget {
  static Page<void> page() => const MaterialPage<void>(child: AuthSignUpPage());
  const AuthSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 25.w,
        actions: [dropDownButtonLang(context)],
      ),
      body: BlocProvider(
        create: (context) =>
            AuthCubit(context.read<AuthenticationRepository>()),
        child: const AuthSignUpView(),
      ),
    );
  }
}
