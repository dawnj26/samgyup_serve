import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/src/enums/order_type.dart';
import 'package:order_repository/src/models/models.dart';
import 'package:package_repository/package_repository.dart';

/// {@template order_repository}
/// Repository for managing orders.
/// {@endtemplate}
class OrderRepository {
  /// {@macro order_repository}
  OrderRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.orderCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;

  /// Creates a new menu order from the given cart item.
  Future<Order> createMenuOrder(CartItem<InventoryItem> cart) async {
    try {
      final order = Order(
        id: ID.unique(),
        cartId: cart.item.id,
        type: OrderType.menu,
        totalPrice: cart.item.price * cart.quantity,
        quantity: cart.quantity,
      );
      final document = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: order.id,
        data: order.toJson(),
      );
      return Order.fromJson(_appwrite.rowToJson(document));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'OrderRepository.createMenuOrder');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Creates a new package order from the given cart item.
  Future<Order> createPackageOrder(CartItem<FoodPackageItem> cart) async {
    try {
      final order = Order(
        id: ID.unique(),
        cartId: cart.item.id,
        type: OrderType.package,
        totalPrice: cart.item.price * cart.quantity,
        quantity: cart.quantity,
      );
      final document = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: order.id,
        data: order.toJson(),
      );
      return Order.fromJson(_appwrite.rowToJson(document));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'OrderRepository.createPackageOrder');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Creates orders for all menu and package items in the cart.
  Future<List<Order>> createOrders({
    required List<CartItem<InventoryItem>> inventoryItems,
    required List<CartItem<FoodPackageItem>> packageItems,
  }) async {
    final orders = <Order>[];
    for (final cart in inventoryItems) {
      final order = await createMenuOrder(cart);
      orders.add(order);
    }

    for (final cart in packageItems) {
      final order = await createPackageOrder(cart);
      orders.add(order);
    }

    return orders;
  }

  /// Fetches orders by their IDs.
  Future<List<Order>> fetchOrdersByIds(List<String> orderIds) async {
    try {
      if (orderIds.isEmpty) return [];
      final documents = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal(r'$id', orderIds),
        ],
      );

      log(
        'Fetched ${documents.total} orders',
        name: 'OrderRepository.fetchOrdersByIds',
      );

      return documents.rows
          .map((e) => Order.fromJson(_appwrite.rowToJson(e)))
          .toList();
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'OrderRepository.fetchOrdersByIds');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
