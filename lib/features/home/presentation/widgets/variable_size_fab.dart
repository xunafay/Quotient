import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paisa/config/routes_name.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/widgets/variable_fab_size.dart';
import 'package:paisa/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:paisa/features/home/presentation/controller/summary_controller.dart';

class HomeFloatingActionButtonWidget extends StatelessWidget {
  const HomeFloatingActionButtonWidget({
    super.key,
    required this.summaryController,
  });

  final SummaryController summaryController;

  void _handleClick(BuildContext context, int page) {
    switch (page) {
      case 1:
        context.goNamed(RoutesName.addAccount.name);
        break;
      case 6:
        context.pushNamed(RoutesName.addRecurring.name);
        break;
      case 0:
        context.pushNamed(RoutesName.addTransaction.name);
        break;
      case 4:
        context.goNamed(RoutesName.addCategory.name);
        break;
      case 2:
        context.goNamed(RoutesName.addDebtCredit.name);
        break;
      case 5:
        break;
    }
  }

  String tooltip(BuildContext context, int page) {
    switch (page) {
      case 1:
        return context.loc.addAccount;
      case 6:
        return context.loc.recurringAction;
      case 0:
        return context.loc.addTransaction;
      case 4:
        return context.loc.addCategory;
      case 2:
        return context.loc.addDebt;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is CurrentIndexState &&
            state.currentPage != 5 &&
            state.currentPage != 3) {
          return VariableFABSize(
            onPressed: () => _handleClick(context, state.currentPage),
            icon: state.currentPage != 3 ? Icons.add : Icons.date_range,
            tooltip: tooltip(context, state.currentPage),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
