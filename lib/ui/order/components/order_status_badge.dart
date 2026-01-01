import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';

extension OrderStatusColorX on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.serving:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
    }
  }
}

class OrderStatusBadge extends StatefulWidget {
  const OrderStatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  State<OrderStatusBadge> createState() => _OrderStatusBadgeState();
}

class _OrderStatusBadgeState extends State<OrderStatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _handleAnimation();
  }

  @override
  void didUpdateWidget(OrderStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _handleAnimation();
    }
  }

  void _handleAnimation() {
    if (widget.status == OrderStatus.pending ||
        widget.status == OrderStatus.serving) {
      unawaited(_controller.repeat(reverse: true));
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.status.color;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - (_controller.value * 0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.status.label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}
