import 'package:delivery_app/core/shared/shared.dart';
import 'package:delivery_app/delegate_app/auth/views/auth_sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constances/media_const.dart';
import '../../../core/theme/colors/landk_colors.dart';
import '../../../core/theme/fonts/landk_fonts.dart';
import '../../../core/tools/tools_widget.dart';
import '../cubit/auth_cubit.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

late AuthCubit cubit;

class _AuthViewState extends State<AuthView> {
  @override
  void initState() {
    cubit = context.read<AuthCubit>();
    super.initState();
  }

  double height = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage.isEmpty
                    ? 'Authentication Failure'
                    : state.errorMessage),
              ),
            );
        }
      },
      child: OfflineWidget(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  vSpace(5),
                  SvgPicture.asset(iLogoOrange),
                  vSpace(5),
                  Text(
                    trans(context).welcome,
                    style: h3,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Text(
                      trans(context).welcomeMessage,
                      textAlign: TextAlign.center,
                      style: h6,
                    ),
                  ),
                  vSpace(5),
                  const _Email(),
                  vSpace(2),
                  const _Password(),
                  vSpace(2),
                  const _ForgotPassword(),
                  vSpace(2),
                  const _SignInBtn(),
                  vSpace(1),
                  const _CreateAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: autoAlignCenter(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Text(
          trans(context).forgotPassword,
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}

class _CreateAccount extends StatelessWidget {
  const _CreateAccount();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: autoAlignCenter(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          children: [
            Text(
              trans(context).newDelegate,
              style: bold,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthSignUpPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: orange,
              ),
              child: Text(
                trans(context).createAccount,
                style: h5.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInBtn extends StatelessWidget {
  const _SignInBtn();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return LandkBtn(
          onTap: () => context.read<AuthCubit>().logInWithCredentials(),
          width: 90,
          height: 7,
          title: state.status == FormzSubmissionStatus.inProgress
              ? SizedBox(
                  width: 5.w,
                  height: 5.h,
                  child: const Center(child: CircularProgressIndicator()))
              : Text(
                  trans(context).signIn,
                  style: btnFont,
                ),
        );
      },
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, next) => previous.email != next.email,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: TextField(
            textDirection: directionField(context),
            key: const Key('email-input'),
            onChanged: (email) => context.read<AuthCubit>().emailChanged(email),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: trans(context).email,
              errorText:
                  state.email.displayError != null ? 'invalid email' : null,
            ),
          ),
        );
      },
    );
  }

  TextDirection directionField(BuildContext context) =>
      locale(context) ? TextDirection.rtl : TextDirection.ltr;
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, next) => previous.password != next.password,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            key: const Key('password-input'),
            onChanged: (password) =>
                context.read<AuthCubit>().passwordChanged(password),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              labelText: trans(context).password,
              errorText: state.password.displayError != null
                  ? 'invalid password'
                  : null,
            ),
          ),
        );
      },
    );
  }
}
