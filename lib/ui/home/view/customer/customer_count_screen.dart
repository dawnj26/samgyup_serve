import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class CustomerCountScreen extends StatelessWidget {
  const CustomerCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppLogoIcon(),
        title: const Text('Pax Count'),
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          const Expanded(child: _SelectGrid()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilledButton(
              onPressed: () {
                context.read<HomeBloc>().add(
                  const HomeEvent.statusChanged(SessionStatus.order),
                );
              },
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectGrid extends StatelessWidget {
  const _SelectGrid();

  @override
  Widget build(BuildContext context) {
    final table = context.select(
      (HomeBloc bloc) => bloc.state.table,
    );
    final customerCount = context.select(
      (HomeBloc bloc) => bloc.state.customerCount,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (ctx, index) {
        final count = index + 1;
        final isSelected = customerCount == count;

        return Card(
          clipBehavior: Clip.hardEdge,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: () {
              context.read<HomeBloc>().add(
                HomeEvent.customerCountChanged(customerCount: count),
              );
            },
            child: Center(
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        );
      },
      itemCount: table?.capacity ?? 1,
    );
  }
}
