import 'package:injectable/injectable.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/enum/category_types.dart';
import 'package:paisa/features/category/data/data_sources/local/category_data_source.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/category/domain/repository/category_repository.dart';

import 'package:paisa/features/category/data/model/category_model.dart';
import 'package:paisa/features/transaction/data/data_sources/local/transaction_data_manager.dart';

@Singleton(as: CategoryRepository)
class CategoryRepositoryImpl extends CategoryRepository {
  CategoryRepositoryImpl({
    required this.dataSources,
    required this.expenseDataManager,
  });

  final LocalCategoryManager dataSources;
  final LocalTransactionManager expenseDataManager;

  @override
  Future<void> add({
    required String? name,
    required int? icon,
    required int? color,
    required String? desc,
    required bool? isBudget,
    required double? budget,
    required CategoryType? type,
  }) {
    return dataSources.add(CategoryModel(
      description: desc ?? '',
      name: name,
      icon: icon,
      budget: budget,
      isBudget: isBudget,
      color: color,
      type: type,
    ));
  }

  @override
  Future<void> clear() => dataSources.clear();

  @override
  Future<void> delete(int key) => dataSources.delete(key);

  @override
  CategoryEntity? fetchById(int? categoryId) =>
      dataSources.findById(categoryId)?.toEntity();

  @override
  List<CategoryEntity> defaultCategories() {
    return dataSources.defaultCategories().toEntities();
  }

  @override
  Future<void> update({
    required int? key,
    required String? name,
    required int? icon,
    required int? color,
    required String? desc,
    required double? budget,
    required bool isBudget,
    required CategoryType? type,
  }) {
    return dataSources.update(CategoryModel(
      description: desc,
      name: name,
      icon: icon,
      budget: budget,
      isBudget: isBudget,
      type: type,
      color: color,
      superId: key,
    ));
  }

  @override
  List<CategoryEntity> categories() {
    return dataSources.categories().toEntities();
  }
}
