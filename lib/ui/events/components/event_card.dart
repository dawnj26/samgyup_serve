import 'dart:convert';

import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/events/components/components.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
    this.padding,
    this.onTap,
    this.onMoreTap,
  });

  final Event event;
  final EdgeInsetsGeometry? padding;
  final void Function(Map<String, dynamic> data)? onTap;
  final void Function(EventMoreOption option)? onMoreTap;

  Map<String, dynamic> get _payload =>
      jsonDecode(event.payload) as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final payload = _payload;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: colorScheme.tertiaryContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: ListTile(
          onTap: () => onTap?.call(
            payload['data'] as Map<String, dynamic>? ?? {},
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
          title: Text('Table ${event.tableNumber} - ${event.type.label}'),
          subtitle: Text(payload['message'] as String? ?? 'No message'),
          trailing: EventMoreOptionButton(
            onSelected: onMoreTap,
          ),
        ),
      ),
    );
  }
}
