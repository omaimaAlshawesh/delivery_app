import 'package:delivery_app/delegate_app/delegate/view/create_page.dart';
import 'package:flutter/material.dart';

import '../../auth/views/auth_page.dart';
import '../../home/views/home_layout.dart';
import '../bloc/app_bloc.dart';

List<Page> onGenerateAuthPage(AppStatus appState, List<Page> pages) {
  switch (appState) {
    case AppStatus.unauthenticated:
      return [AuthPage.page()];
    case AppStatus.authenticated:
      return [HomeLayout.page()];
    case AppStatus.unauthorize:
      return [CreateDelegatePage.page()];
    default:
      return [AuthPage.page()];
  }
}
