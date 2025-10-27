import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/stock/inventory_stock_bloc.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class AddStockScreen extends StatelessWidget {
  const AddStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: _Title(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _Stock(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _Threshold(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _Expire(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: FilledButton(
                onPressed: () {},
                child: const Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final item = context.select(
      (InventoryStockBloc bloc) => bloc.state.item,
    );

    return Text('Add Stock (${item.name})');
  }
}

class _Expire extends StatelessWidget {
  const _Expire();

  @override
  Widget build(BuildContext context) {
    return ExpirationInput(
      onChanged: (date) {
        context.read<InventoryStockBloc>().add(
          InventoryStockEvent.expirationChanged(expiration: date),
        );
      },
    );
  }
}

class _Threshold extends StatelessWidget {
  const _Threshold();

  @override
  Widget build(BuildContext context) {
    final lowStockThreshold = context.select(
      (InventoryStockBloc bloc) => bloc.state.lowStockThreshold,
    );

    final errMessage = lowStockThreshold.displayError?.message;

    return LowStockThresholdInput(
      errorText: errMessage,
      onChanged: (value) {
        context.read<InventoryStockBloc>().add(
          InventoryStockEvent.lowStockThresholdChanged(
            lowStockThreshold: value,
          ),
        );
      },
    );
  }
}

class _Stock extends StatelessWidget {
  const _Stock();

  @override
  Widget build(BuildContext context) {
    final stock = context.select(
      (InventoryStockBloc bloc) => bloc.state.stock,
    );

    final errMessage = stock.displayError?.message;

    return StockInput(
      errorText: errMessage,
      onChanged: (value) {
        context.read<InventoryStockBloc>().add(
          InventoryStockEvent.stockChanged(stock: value),
        );
      },
    );
  }
}
