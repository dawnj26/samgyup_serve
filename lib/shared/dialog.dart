import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

void showLoadingDialog({
  required BuildContext context,
  String message = 'Loading...',
}) {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (ctx) {
        return LoadingDialog(
          message: message,
        );
      },
    ),
  );
}

void showErrorDialog({
  required BuildContext context,
  required String message,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (ctx) {
        return ErrorDialog(
          message: message,
        );
      },
    ),
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

void showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  void Function()? onOk,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (ctx) {
        return PopScope(
          canPop: false,
          child: InfoDialog(
            title: title,
            message: message,
            onOk: onOk,
          ),
        );
      },
    ),
  );
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? message,
  void Function()? onConfirmed,
  void Function()? onCancelled,
  bool barrierDismissible = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      return ConfirmationDialog(
        title: title,
        message: message,
        onConfirmed: onConfirmed,
        onCancelled: onCancelled,
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

Future<int?> showQuantityDialog({
  required BuildContext context,
  required int initialValue,
  String? title,
  int? maxValue,
}) async {
  final result = await showDialog<int>(
    context: context,
    useRootNavigator: false,
    builder: (ctx) {
      return QuantityDialog(
        initialValue: initialValue,
        title: title,
        maxValue: maxValue,
      );
    },
  );

  return result;
}

void showImageDialog({
  required BuildContext context,
  required String fileId,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (ctx) {
        return ImageDialog(fileId: fileId);
      },
    ),
  );
}

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
}) async {
  final result = await showDialog<String>(
    context: context,
    useRootNavigator: false,
    builder: (ctx) {
      return TextInputDialog(title: title, initialValue: initialValue);
    },
  );

  return result;
}
