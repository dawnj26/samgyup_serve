import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:menu_repository/menu_repository.dart';
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
  Future<Order> createMenuOrder(CartItem<MenuItem> cart) async {
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
  Future<Order> createPackageOrder(CartItem<FoodPackage> cart) async {
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
    required List<CartItem<MenuItem>> menuItems,
    required List<CartItem<FoodPackage>> packageItems,
  }) async {
    final orders = <Order>[];
    for (final cart in menuItems) {
      final order = await createMenuOrder(cart);
      orders.add(order);
    }
    for (final cart in packageItems) {
      final order = await createPackageOrder(cart);
      orders.add(order);
    }
    return orders;
  }
}
