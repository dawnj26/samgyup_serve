import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/ingredient/select/ingredient_select_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class IngredientSelectScreen extends StatefulWidget {
  const IngredientSelectScreen({super.key});

  @override
  State<IngredientSelectScreen> createState() => _IngredientSelectScreenState();
}

class _IngredientSelectScreenState extends State<IngredientSelectScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Ingredients'),
      ),
      body: BlocBuilder<IngredientSelectBloc, IngredientSelectState>(
        builder: (context, state) {
          return ListView.builder(
            itemBuilder: (ctx, i) {
              return i >= state.items.length
                  ? const BottomLoader()
                  : ListTile(
                      title: Text(state.items[i].name),
                      subtitle: Text('Quantity: ${state.items[i].stock}'),
                      onTap: () {
                        // Handle item tap
                      },
                    );
            },
            itemCount: state.hasReachedMax
                ? state.items.length
                : state.items.length + 1,
          );
        },
      ),
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<IngredientSelectBloc>().add(
        const IngredientSelectEvent.loadMore(),
      );
    }
  }
}
