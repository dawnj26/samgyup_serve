import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/log/log_list_bloc.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/logs/components/action_filters.dart';
import 'package:samgyup_serve/ui/logs/components/log_details_sheet.dart';
import 'package:samgyup_serve/ui/logs/components/logs_card_tile.dart';

class LogsListScreen extends StatelessWidget {
  const LogsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Logs'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
            child: ActionFilters(
              onActionSelected: (selected) {
                context.read<LogListBloc>().add(
                  LogListEvent.filterByAction(selected),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<LogListBloc, LogListState>(
              builder: (context, state) {
                switch (state.status) {
                  case LoadingStatus.initial || LoadingStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case LoadingStatus.success:
                    if (state.logs.isEmpty) {
                      return const Center(
                        child: Text('No logs found.'),
                      );
                    }
                    return InfiniteScrollLayout(
                      onLoadMore: () => context.read<LogListBloc>().add(
                        const LogListEvent.loadMore(),
                      ),
                      slivers: [
                        SliverList.builder(
                          itemCount: state.hasReachedMax
                              ? state.logs.length
                              : state.logs.length + 1,
                          itemBuilder: (context, index) {
                            if (index >= state.logs.length) {
                              return const BottomLoader();
                            }

                            final log = state.logs[index];
                            return LogsCardTile(
                              log: log,
                              onTap: () async {
                                await showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      LogDetailsSheet(log: log),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  case LoadingStatus.failure:
                    return Center(
                      child: Text('Error: ${state.errorMessage}'),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
