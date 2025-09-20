import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Checks if the stack contains single route
/// and navigates to the previous route accordingly.
void goToPreviousRoute(BuildContext context) {
  final scope = RouterScope.of(context);

  final canPop = scope.controller.canPop();

  if (canPop) {
    unawaited(scope.controller.maybePopTop());
  }
}
