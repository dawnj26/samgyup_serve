import 'package:auto_route/auto_route.dart';
import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/device/select/device_select_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/device/components/components.dart';

class DeviceSelectScreen extends StatelessWidget {
  const DeviceSelectScreen({super.key, this.onSelected});

  final void Function(Device device)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Select Device'),
      ),
      body: InfiniteScrollLayout(
        onLoadMore: () => context.read<DeviceSelectBloc>().add(
          const DeviceSelectEvent.loadMore(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            sliver: _DeviceList(onSelected),
          ),
        ],
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList(this.onSelected);

  final void Function(Device device)? onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceSelectBloc, DeviceSelectState>(
      builder: (context, state) {
        if (state.status == DeviceSelectStatus.loading ||
            state.status == DeviceSelectStatus.initial) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == DeviceSelectStatus.failure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(state.errorMessage ?? 'Something went wrong!'),
            ),
          );
        }

        final devices = state.devices;
        final hasReachedMax = state.hasReachedMax;

        if (devices.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('No devices found.'),
            ),
          );
        }

        return SliverList.builder(
          itemCount: hasReachedMax ? devices.length : devices.length + 1,
          itemBuilder: (context, index) {
            if (index >= devices.length) {
              return const BottomLoader();
            }

            final device = devices[index];
            final table = state.tables[device.id];

            return DeviceTile(
              device: device,
              table: table,
              onTap: () => onSelected?.call(device),
            );
          },
        );
      },
    );
  }
}
