import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:paisa/core/enum/transaction_type.dart';
import 'package:paisa/core/use_case/use_case.dart';
import 'package:paisa/features/category/domain/repository/category_repository.dart';

@singleton
class AddCategoryUseCase implements UseCase<void, AddCategoryParams> {
  AddCategoryUseCase({required this.categoryRepository});

  final CategoryRepository categoryRepository;

  @override
  Future<void> call(AddCategoryParams params) {
    return categoryRepository.add(
      name: params.name,
      desc: params.description,
      icon: params.icon,
      budget: params.budget,
      isBudget: params.isBudget,
      color: params.color,
      type: params.type,
    );
  }
}

class AddCategoryParams extends Equatable {
  final double? budget;
  final int? color;
  final String? description;
  final int? icon;
  final bool isBudget;
  final TransactionType type;
  final String? name;

  const AddCategoryParams({
    this.budget,
    this.color,
    this.description,
    this.icon,
    this.isBudget = false,
    this.type = TransactionType.expense,
    this.name,
  });

  @override
  List<Object?> get props => [
        budget,
        color,
        description,
        icon,
        isBudget,
        type,
        name,
      ];
}
