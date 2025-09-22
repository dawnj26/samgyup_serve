import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';

class EventFilterButton extends StatefulWidget {
  const EventFilterButton({super.key, this.onChanged});

  final void Function(EventStatus status)? onChanged;

  @override
  State<EventFilterButton> createState() => _EventFilterButtonState();
}

class _EventFilterButtonState extends State<EventFilterButton> {
  final List<EventStatus> list = EventStatus.values;
  EventStatus value = EventStatus.pending;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButton<EventStatus>(
      value: value,
      style: textTheme.headlineSmall,
      onChanged: (EventStatus? value) {
        setState(() {
          this.value = value!;
        });

        widget.onChanged?.call(this.value);
      },
      items: list.map<DropdownMenuItem<EventStatus>>((EventStatus value) {
        return DropdownMenuItem<EventStatus>(
          value: value,
          child: Text(value.label),
        );
      }).toList(),
    );
  }
}
