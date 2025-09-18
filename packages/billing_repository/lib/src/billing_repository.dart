import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/src/enums/enums.dart';
import 'package:billing_repository/src/models/models.dart';
import 'package:order_repository/order_repository.dart';

/// {@template billing_repository}
/// Repository for managing billing operations.
/// {@endtemplate}
class BillingRepository {
  /// {@macro billing_repository}
  BillingRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.invoiceCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;

  /// Creates a new invoice in the database.
  Future<Invoice> createInvoice({
    required List<Order> orders,
    required String code,
    String? paymentId,
  }) async {
    try {
      final orderIds = orders.map((order) => order.id).toList();
      final subtotalAmount = orders.fold<double>(
        0,
        (sum, order) => sum + (order.totalPrice),
      );
      final lastNumber = await _getLastInvoiceNumber();

      final invoice = Invoice(
        id: ID.unique(),
        code: '$code-${lastNumber + 1}',
        orderIds: orderIds,
        subtotalAmount: subtotalAmount,
        taxAmount: 0,
        discountAmount: 0,
        totalAmount: subtotalAmount,
        status: InvoiceStatus.pending,
        paymentId: paymentId,
        number: lastNumber + 1,
      );

      final doc = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: invoice.id,
        data: invoice.toJson(),
      );

      return Invoice.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.createInvoice');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves an invoice by its ID.
  Future<Invoice> getInvoiceById(String id) async {
    try {
      final doc = await _appwrite.databases.getRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: id,
      );

      return Invoice.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.getInvoiceById');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Updates the orders associated with an invoice.
  Future<Invoice> addOrders({
    required Invoice invoice,
    required List<Order> orders,
  }) async {
    try {
      final orderIds = orders.map((order) => order.id).toList();
      final subtotalAmount =
          orders.fold<double>(
            0,
            (sum, order) => sum + (order.totalPrice),
          ) +
          invoice.totalAmount;

      final updatedInvoice = invoice.copyWith(
        orderIds: [...invoice.orderIds, ...orderIds],
        subtotalAmount: subtotalAmount,
        totalAmount: subtotalAmount,
      );

      final doc = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: updatedInvoice.id,
        data: updatedInvoice.toJson(),
      );

      return Invoice.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.updateOrders');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  Future<int> _getLastInvoiceNumber() async {
    try {
      final documents = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.select(['number']),
          Query.orderDesc(r'$createdAt'),
          Query.limit(1),
        ],
      );
      if (documents.total == 0) {
        return 0;
      }

      final number = documents.rows.first.data['number'] as int;

      return number;
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository._getLastInvoiceNumber');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
