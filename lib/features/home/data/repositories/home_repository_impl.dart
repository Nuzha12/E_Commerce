import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<List<BannerEntity>> getBanners() => dataSource.getBanners();

  @override
  Future<List<CategoryEntity>> getCategories() => dataSource.getCategories();
}