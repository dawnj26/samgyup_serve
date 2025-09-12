import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:table_repository/table_repository.dart' as t;

class DeviceTile extends StatelessWidget {
  const DeviceTile({required this.device, super.key, this.table, this.onTap});

  final Device device;
  final t.Table? table;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.phone_android_rounded),
      title: Row(
        children: [
          Text(device.name),
          if (table != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.arrow_right_alt_rounded),
            const SizedBox(width: 8),
            Text(
              'Table ${table!.number}',
            ),
          ],
        ],
      ),
      subtitle: Text(device.id),
      onTap: onTap,
    );
  }
}
