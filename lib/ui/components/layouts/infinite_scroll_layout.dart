import 'package:flutter/widgets.dart';

class InfiniteScrollLayout extends StatefulWidget {
  const InfiniteScrollLayout({
    required this.slivers,
    super.key,
    this.onLoadMore,
    this.threshold = 0.9,
  });

  final void Function()? onLoadMore;
  final List<Widget> slivers;
  final double threshold;

  @override
  State<InfiniteScrollLayout> createState() => _InfiniteScrollLayoutState();
}

class _InfiniteScrollLayoutState extends State<InfiniteScrollLayout> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.onLoadMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: widget.slivers,
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * widget.threshold);
  }

  void _onScroll() {
    if (_isBottom) {
      widget.onLoadMore?.call();
    }
  }
}
