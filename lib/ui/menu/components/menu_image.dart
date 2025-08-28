import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuImage extends StatelessWidget {
  const MenuImage({required this.imageFileName, super.key});

  final String imageFileName;

  @override
  Widget build(BuildContext context) {
    return BucketImage(
      onLoad: () {
        return context.read<MenuRepository>().getMenuItemImage(
          imageFileName,
        );
      },
    );
  }
}
