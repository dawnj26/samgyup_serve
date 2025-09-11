import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';

class DeviceSelectScreen extends StatelessWidget {
  const DeviceSelectScreen({super.key, this.onSelected});

  final void Function(Device device)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Device'),
      ),
      body: const Center(
        child: Text('Device Select Screen'),
      ),
    );
  }
}
