import 'package:flutter/material.dart';

import 'menu_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MenuPage(),
    );
  }
}
