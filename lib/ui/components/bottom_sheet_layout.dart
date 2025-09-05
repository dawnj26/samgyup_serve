import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({
    required this.child,
    this.height = 0,
    super.key,
    this.fullscreen = false,
    this.padding,
  }) : assert(
         height > 0 || fullscreen,
         'Height must be greater than 0 if not fullscreen',
       );

  final double height;
  final Widget child;
  final bool fullscreen;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (fullscreen) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.drag_handle_rounded)],
            ),
          ),
          Expanded(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.drag_handle_rounded)],
            ),
          ),
          Expanded(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
