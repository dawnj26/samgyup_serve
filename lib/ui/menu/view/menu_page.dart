import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/ui/menu/view/menu_screen.dart';

@RoutePage()
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(
        menuRepository: context.read(),
      )..add(const MenuEvent.started()),
      child: const MenuScreen(),
    );
  }
}
