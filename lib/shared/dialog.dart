import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

void showLoadingDialog({
  required BuildContext context,
  String message = 'Loading...',
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (ctx) {
      return LoadingDialog(
        message: message,
      );
    },
  );
}

void showErrorDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (ctx) {
      return ErrorDialog(
        message: message,
      );
    },
  );
}

Future<bool> showDeleteDialog({
  required BuildContext context,
  String? title,
  String? message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (ctx) {
      return DeleteDialog(
        title: title,
        message: message,
      );
    },
  );

  return result ?? false;
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return ConfirmationDialog(
        title: title,
        message: message,
      );
    },
  );

  return result ?? false;
}
