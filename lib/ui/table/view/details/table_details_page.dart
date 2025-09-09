import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/table/delete/table_delete_bloc.dart';
import 'package:samgyup_serve/bloc/table/details/table_details_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/table/view/details/table_details_screen.dart';
import 'package:table_repository/table_repository.dart' as t;

@RoutePage()
class TableDetailsPage extends StatelessWidget implements AutoRouteWrapper {
  const TableDetailsPage({
    required this.id,
    required this.table,
    super.key,
    this.onChanged,
  });

  final String id;
  final t.Table table;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TableDeleteBloc, TableDeleteState>(
      listener: (context, state) {
        switch (state.status) {
          case TableDeleteStatus.loading:
            showLoadingDialog(context: context, message: 'Deleting table...');
          case TableDeleteStatus.success:
            context.router.pop();
            goToPreviousRoute(context);
            showSnackBar(context, 'Table deleted successfully');
            onChanged?.call();
          case TableDeleteStatus.failure:
            context.router.pop();
            showErrorDialog(
              context: context,
              message: state.errorMessage ?? 'An unknown error occurred',
            );
          case TableDeleteStatus.initial:
            break;
        }
      },
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          final isDirty = context.read<TableDetailsBloc>().state.isDirty;
          if (didPop && isDirty) {
            onChanged?.call();
          }
        },
        child: const TableDetailsScreen(),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TableDetailsBloc(
            tableRepository: context.read<t.TableRepository>(),
            table: table,
          ),
        ),
        BlocProvider(
          create: (context) => TableDeleteBloc(tableRepository: context.read()),
        ),
      ],
      child: this,
    );
  }
}
