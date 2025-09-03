import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Checks if the stack contains single route
/// and navigates to the previous route accordingly.
void goToPreviousRoute(BuildContext context) {
  final canPop = context.router.canPop(ignoreParentRoutes: true);

  if (canPop) {
    context.router.pop();
  } else {
    context.router.parent<StackRouter>()?.maybePop();
  }
}
