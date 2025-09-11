import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';

class DeviceChip extends StatelessWidget {
  const DeviceChip({required this.device, super.key, this.onRemoved});

  final Device device;
  final void Function()? onRemoved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            device.name,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          IconButton(
            iconSize: 20,
            icon: const Icon(
              Icons.close_rounded,
            ),
            onPressed: onRemoved,
          ),
        ],
      ),
    );
  }
}
