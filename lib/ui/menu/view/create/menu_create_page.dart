import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/create/menu_create_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';

@RoutePage()
class MenuCreatePage extends StatelessWidget implements AutoRouteWrapper {
  const MenuCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        MenuFormRoute(),
        MenuIngredientRoute(),
      ],
      builder: (context, child, pageController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add menu'),
          ),
          body: child,
          bottomNavigationBar: const _MenuCreateNagivationBar(),
        );
      },
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCreateBloc(
        menuRepository: context.read(),
      ),
      child: BlocListener<MenuCreateBloc, MenuCreateState>(
        listener: (context, state) {
          switch (state) {
            case MenuCreateSubmitting():
              showLoadingDialog(context: context, message: 'Creating menu...');
            case MenuCreateSuccess():
              context.router.popUntilRouteWithName(MenuRoute.name);
              showSnackBar(context, 'Menu created successfully');
            case MenuCreateFailure(:final errorMessage):
              context.router.pop();
              showSnackBar(context, errorMessage ?? 'Failed to create menu');
          }
        },
        child: this,
      ),
    );
  }
}

class _MenuCreateNagivationBar extends StatefulWidget {
  const _MenuCreateNagivationBar();

  @override
  State<_MenuCreateNagivationBar> createState() =>
      _MenuCreateNagivationBarState();
}

class _MenuCreateNagivationBarState extends State<_MenuCreateNagivationBar> {
  bool _isEndOfPage = false;

  void _updateIsEndOfPage(int index, int pageCount) {
    final isEndOfPage = index == pageCount - 1;

    if (isEndOfPage != _isEndOfPage) {
      return setState(() {
        _isEndOfPage = isEndOfPage;
      });
    }

    context.read<MenuCreateBloc>().add(const MenuCreateEvent.submitted());
  }

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                if (tabsRouter.activeIndex > 0) {
                  tabsRouter.setActiveIndex(tabsRouter.activeIndex - 1);
                }

                _updateIsEndOfPage(
                  tabsRouter.activeIndex,
                  tabsRouter.pageCount,
                );
              },
              child: const Text('Back'),
            ),
            BlocBuilder<MenuCreateBloc, MenuCreateState>(
              buildWhen: (previous, current) =>
                  previous.isDetailsValid != current.isDetailsValid,
              builder: (context, state) {
                return FilledButton.icon(
                  onPressed: state.isDetailsValid
                      ? () {
                          if (tabsRouter.activeIndex <
                              tabsRouter.pageCount - 1) {
                            tabsRouter.setActiveIndex(
                              tabsRouter.activeIndex + 1,
                            );
                          }

                          _updateIsEndOfPage(
                            tabsRouter.activeIndex,
                            tabsRouter.pageCount,
                          );
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    !_isEndOfPage ? 'Next' : 'Finish',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
