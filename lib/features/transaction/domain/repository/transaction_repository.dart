import 'package:dartz/dartz.dart';
import 'package:paisa/core/enum/transaction_type.dart';
import 'package:paisa/core/error/failures.dart';
import 'package:paisa/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, bool>> addExpense(
    String? name,
    double? amount,
    DateTime? time,
    int? category,
    int? account,
    TransactionType? transactionType,
    String? description,
  );

  Future<void> clearExpense(int expenseId);

  TransactionEntity? fetchExpenseFromId(int expenseId);

  List<TransactionEntity> expenses(int? accountId);

  List<TransactionEntity> fetchExpensesFromAccountId(int accountId);

  List<TransactionEntity> fetchExpensesFromCategoryId(int accountId);

  Future<void> deleteExpensesByAccountId(int accountId);

  Future<void> deleteExpensesByCategoryId(int categoryId);

  Future<void> updateExpense(
    int key,
    String? name,
    double? currency,
    DateTime? time,
    int? categoryId,
    int? accountId,
    TransactionType? transactionType,
    String? description,
  );

  Future<void> clearAll();

  List<TransactionEntity> filterExpenses(
    String query,
    List<int> accounts,
    List<int> categories,
  );
}
