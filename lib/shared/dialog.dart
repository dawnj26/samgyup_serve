import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

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

Future<int?> showAddCartItemDialog({
  required BuildContext context,
  required String name,
  required String description,
  required double price,
  required int maxQuantity,
  VoidCallback? onTap,
  int? initialValue,
  String? imageId,
  Widget? content,
}) async {
  final result = await showDialog<int>(
    context: context,
    useRootNavigator: false,
    builder: (ctx) {
      return AddCartItemDialog(
        onTap: onTap,
        initialValue: initialValue ?? 1,
        name: name,
        description: description,
        price: price,
        maxQuantity: maxQuantity,
        imageId: imageId,
        content: content,
      );
    },
  );

  return result;
}
