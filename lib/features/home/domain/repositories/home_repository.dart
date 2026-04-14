import '../entities/banner_entity.dart';
import '../entities/category_entity.dart';

abstract class HomeRepository {
  Future<List<BannerEntity>> getBanners();
  Future<List<CategoryEntity>> getCategories();
}