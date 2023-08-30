import 'package:flutter/material.dart';

import '../widgets/home_page.dart';
import '../widgets/menu_page.dart';

enum HomeState {
  home,

  menu,
}

List<Page> onGenerateHomePage(HomeState state, List<Page> pages) {
  switch (state) {
    case HomeState.home:
      return [HomePage.page()];

    case HomeState.menu:
      return [MenuPage.page()];
  }
}
