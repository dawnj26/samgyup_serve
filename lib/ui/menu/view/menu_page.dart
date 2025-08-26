import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:samgyup_serve/ui/menu/view/menu_screen.dart';

@RoutePage()
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MenuScreen();
  }
}
