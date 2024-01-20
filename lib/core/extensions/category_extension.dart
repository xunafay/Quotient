import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/core/extensions/expense_extensions.dart';
import 'package:paisa/features/category/data/model/category_model.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/transaction/domain/entities/transaction.dart';

extension CategoryModelHelper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      icon: icon,
      name: name,
      color: color,
      budget: budget,
      description: description,
      isBudget: isBudget,
      superId: superId,
      type: type,
    );
  }
}

extension CategoryModelsHelper on Iterable<CategoryModel> {
  List<Map<String, dynamic>> toJson() {
    return map((e) => e.toJson()).toList();
  }

  Iterable<CategoryModel> sort() =>
      sorted((a, b) => a.name!.compareTo(b.name!));

  List<CategoryEntity> toEntities() =>
      sort().map((categoryModel) => categoryModel.toEntity()).toList();

  List<CategoryEntity> toBudgetEntities() => sort()
      .map((categoryModel) => categoryModel.toEntity())
      .where((element) => element.isBudget != null)
      .where((element) => element.isBudget!)
      .toList();
}

extension CategoryHelper on CategoryEntity {
  Color get foregroundColor => Color(color ?? Colors.amber.shade100.value);
  Color get backgroundColor =>
      Color(color ?? Colors.amber.shade100.value).withOpacity(0.25);

  double get finalBudget => budget ?? 0.0;
  DateTime? _firstActiveMonth(Iterable<TransactionEntity> transactions) {
    return transactions
        .map((transaction) => transaction.time)
        .where((e) => e != null)
        .sorted((a, b) => a!.compareTo(b!))
        .firstOrNull;
  }

  double monthlyAvailableBudgetSince(Iterable<TransactionEntity> transactions) {
    final DateTime? firstUsed = _firstActiveMonth(transactions);
    if (firstUsed == null) {
      return 0.0;
    }
    debugPrint('firstUsed: $firstUsed for $name');
    final DateTime now = DateTime.now();

    int years = now.year - firstUsed.year;
    int months = now.month - firstUsed.month;
    if (months < 0) {
      months += 12;
      years--;
    }
    final int totalMonths =
        (years * 12) + months + 1; // + 1 to account for current months budget

    debugPrint('Calculated total months: $totalMonths');

    return finalBudget * totalMonths;
  }

  double remainingBudget(Iterable<TransactionEntity> transactions) {
    if (type == TransactionType.income) {
      return 0.0;
    }
    final double totalExpenses = transactions.totalExpense;
    final double totalBudget = monthlyAvailableBudgetSince(transactions);
    return totalBudget - totalExpenses;
  }
}
