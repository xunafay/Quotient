import 'package:injectable/injectable.dart';
import 'package:paisa/core/use_case/use_case.dart';
import 'package:paisa/features/transaction/domain/entities/transaction.dart';
import 'package:paisa/features/transaction/domain/repository/transaction_repository.dart';

@singleton
class GetTransactionsByCategoryIdUseCase
    implements
        UseCase<List<TransactionEntity>, ParamsGetTransactionsByCategoryId> {
  GetTransactionsByCategoryIdUseCase({required this.expenseRepository});

  final TransactionRepository expenseRepository;

  @override
  List<TransactionEntity> call(ParamsGetTransactionsByCategoryId params) =>
      expenseRepository.fetchExpensesFromCategoryId(params.categoryId);
}

class ParamsGetTransactionsByCategoryId {
  ParamsGetTransactionsByCategoryId(this.categoryId);

  final int categoryId;
}
