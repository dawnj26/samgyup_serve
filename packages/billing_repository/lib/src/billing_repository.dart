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
  String get _paymentCollectionId => _appwrite.environment.paymentCollectionId;
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

  /// Subscribes to real-time updates for a specific invoice.
  RealtimeSubscription invoiceState(String invoiceId) {
    return _appwrite.realtime.subscribe([
      'databases.$_databaseId.tables.$_collectionId.rows.$invoiceId',
    ]);
  }

  /// Creates a new payment record in the database.
  Future<Payment> createPayment({
    required double amount,
    required PaymentMethod method,
    String? transactionRef,
  }) async {
    try {
      final payment = Payment(
        id: ID.unique(),
        amount: amount,
        method: method,
        transactionRef: transactionRef,
      );

      final doc = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _paymentCollectionId,
        rowId: payment.id,
        data: payment.toJson(),
      );

      return Payment.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.createPayment');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Marks an invoice as paid with the given payment.
  Future<Invoice> markAsPaid({
    required Invoice invoice,
    required Payment payment,
  }) async {
    try {
      final updatedInvoice = invoice.copyWith(
        status: InvoiceStatus.paid,
        paymentId: payment.id,
      );

      final doc = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: updatedInvoice.id,
        data: updatedInvoice.toJson(),
      );

      return Invoice.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.markAsPaid');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Gets revenue data based on the specified period.
  ///
  /// Returns a list of maps containing 'date' and 'revenue' keys.
  /// - For [Period.week]: Returns 7 days of revenue data starting from Sunday
  /// - For [Period.month]: Returns 4 weeks of revenue data
  /// - For [Period.year]: Returns 12 months of revenue
  ///  data starting from January
  Future<List<Map<String, dynamic>>> getRevenueData(Period period) async {
    try {
      final now = DateTime.now().toUtc();
      final revenueData = <Map<String, dynamic>>[];

      switch (period) {
        case Period.week:
          // Find the most recent Sunday
          final daysFromSunday = now.weekday % 7;
          final lastSunday = now.subtract(Duration(days: daysFromSunday));

          for (var i = 0; i < 7; i++) {
            final date = lastSunday.add(Duration(days: i));
            final startOfDay = DateTime.utc(date.year, date.month, date.day);
            final endOfDay = startOfDay.add(const Duration(days: 1));

            final revenue = await _getRevenueForDateRange(startOfDay, endOfDay);
            revenueData.add({
              'date': startOfDay.toIso8601String(),
              'revenue': revenue,
            });
          }

        case Period.month:
          final lastDayOfMonth = DateTime.utc(now.year, now.month + 1, 0);
          final totalDays = lastDayOfMonth.day;
          final daysPerPart = (totalDays / 4).ceil();

          for (var i = 0; i < 4; i++) {
            final startDay = (i * daysPerPart) + 1;
            final endDay = ((i + 1) * daysPerPart).clamp(1, totalDays);

            final startOfPeriod = DateTime.utc(now.year, now.month, startDay);
            final endOfPeriod = DateTime.utc(now.year, now.month, endDay + 1);

            final revenue = await _getRevenueForDateRange(
              startOfPeriod,
              endOfPeriod,
            );
            revenueData.add({
              'date': startOfPeriod.toIso8601String(),
              'revenue': revenue,
            });
          }

        case Period.year:
          // Start from January of current year
          for (var i = 0; i < 12; i++) {
            final startOfMonth = DateTime.utc(now.year, i + 1);
            final endOfMonth = DateTime.utc(now.year, i + 2);

            final revenue = await _getRevenueForDateRange(
              startOfMonth,
              endOfMonth,
            );
            revenueData.add({
              'date': startOfMonth.toIso8601String(),
              'revenue': revenue,
            });
          }
      }

      return revenueData;
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository.getRevenueData');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Helper method to get total revenue for a specific date range.
  Future<double> _getRevenueForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final documents = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('status', InvoiceStatus.paid.name),
          Query.greaterThanEqual(r'$createdAt', startDate.toIso8601String()),
          Query.lessThan(r'$createdAt', endDate.toIso8601String()),
          Query.select(['totalAmount']),
          Query.limit(1000),
        ],
      );

      double totalRevenue = 0;
      for (final doc in documents.rows) {
        final amount = doc.data['totalAmount'] as num? ?? 0;
        totalRevenue += amount;
      }

      return totalRevenue;
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'BillingRepository._getRevenueForDateRange');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
