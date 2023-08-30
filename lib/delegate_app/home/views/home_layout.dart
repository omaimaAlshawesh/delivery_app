import 'package:delivery_app/core/theme/fonts/landk_fonts.dart';
import 'package:delivery_app/delegate_app/delegate/repository/delegate_repository.dart';
import 'package:delivery_app/delegate_app/delegate/view/profile_page.dart';
import 'package:delivery_app/delegate_app/home/widgets/home_page.dart';
import 'package:delivery_app/delegate_app/home/widgets/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import '../../../core/theme/colors/landk_colors.dart';
import '../../../core/tools/tools_widget.dart';

class HomeLayout extends StatefulWidget {
  static Page page() => const MaterialPage(child: HomeLayout());
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiddenDrawerMenu(
        typeOpen: locale(context) ? TypeOpen.FROM_RIGHT : TypeOpen.FROM_LEFT,
        screens: [
          ScreenHiddenDrawer(
            _itemHiddenMenu(trans(context).home),
            const HomePage(),
          ),
          ScreenHiddenDrawer(
            _itemHiddenMenu(trans(context).myAccount),
            ProfilePage(
              delegateRepository: DelegateRepository(),
            ),
          ),
          ScreenHiddenDrawer(
            _itemHiddenMenu(trans(context).settings),
            const MenuPage(),
          ),
          ScreenHiddenDrawer(
            _itemHiddenMenu(trans(context).contactUs),
            const MenuPage(),
          ),
        ],
        backgroundColorMenu: orange,
      ),
    );
  }

  ItemHiddenMenu _itemHiddenMenu(title) {
    return ItemHiddenMenu(name: title, baseStyle: h4, selectedStyle: h3);
  }
}
