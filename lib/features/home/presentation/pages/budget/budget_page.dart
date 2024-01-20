import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:paisa/core/common.dart';
import 'package:paisa/features/category/data/model/category_model.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:paisa/features/settings/domain/use_case/settings_use_case.dart';
import 'package:paisa/features/transaction/domain/entities/transaction.dart';
import 'package:paisa/main.dart';
import 'package:paisa/features/home/presentation/controller/summary_controller.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({
    super.key,
    required this.summaryController,
  });

  final SummaryController summaryController;

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final SettingsUseCase settingsUseCase = getIt.get();

  @override
  Widget build(BuildContext context) {
    late bool rollover =
        settingsUseCase.get(userBudgetRollOverKey, defaultValue: false);

    return PaisaAnnotatedRegionWidget(
      color: context.background,
      child: ValueListenableBuilder<Box<CategoryModel>>(
        valueListenable: getIt.get<Box<CategoryModel>>().listenable(),
        builder: (_, value, child) {
          final categories = value.values.toBudgetEntities();
          if (categories.isEmpty) {
            return EmptyWidget(
              icon: MdiIcons.timetable,
              title: context.loc.emptyBudgetMessageTitle,
              description: context.loc.emptyBudgetMessageSubTitle,
            );
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final CategoryEntity category = categories[index];
              final List<TransactionEntity> expenses =
                  BlocProvider.of<HomeBloc>(context)
                      .fetchExpensesFromCategoryId(category.superId!)
                      .expenseList;
              return BudgetItem(
                category: category,
                expenses: expenses,
                rollover: rollover,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        },
      ),
    );
  }
}

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    super.key,
    required this.category,
    required this.expenses,
    required this.rollover,
  });

  final CategoryEntity category;
  final List<TransactionEntity> expenses;
  final bool rollover;

  @override
  Widget build(BuildContext context) {
    final double totalExpenses = expenses.totalExpense;
    double totalBudget = 0;
    double difference = 0;
    if (rollover) {
      totalBudget = (category.monthlyAvailableBudgetSince(expenses) == 0.0
          ? 1
          : category.monthlyAvailableBudgetSince(expenses));
      difference = category.remainingBudget(expenses);
    } else {
      totalBudget = (category.finalBudget == 0.0 ? 1 : category.finalBudget);
      difference = category.finalBudget - totalExpenses;
    }

    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundColor: category.backgroundColor,
        child: Icon(
          IconData(
            category.icon ?? 0,
            fontFamily: fontFamilyName,
            fontPackage: fontFamilyPackageName,
          ),
          color: category.foregroundColor,
        ),
      ),
      title: Text(category.name ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Limit: ',
                    style: context.bodyMedium?.copyWith(
                      color: context.bodySmall?.color,
                    ),
                    children: [
                      TextSpan(
                        text:
                            ' ${rollover ? category.monthlyAvailableBudgetSince(expenses).toFormateCurrency(context) : category.finalBudget.toFormateCurrency(context)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Spent: ',
                    style: context.bodyMedium?.copyWith(
                      color: context.bodySmall?.color,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${totalExpenses.toFormateCurrency(context)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Remaining: ',
                    style: context.bodyMedium?.copyWith(
                      color: context.bodySmall?.color,
                    ),
                    children: [
                      TextSpan(
                        text:
                            ' ${(difference < 0 ? 0.0 : difference).toFormateCurrency(context)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalExpenses / totalBudget,
              color: category.foregroundColor,
              backgroundColor: category.backgroundColor,
            ),
          )
        ],
      ),
    );
  }
}
