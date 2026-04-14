import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<ProductEntity>> getProducts() => dataSource.getProducts();

  @override
  Future<ProductEntity> getProductById(int id) => dataSource.getProductById(id);

  @override
  Future<List<ProductEntity>> searchProducts(String query) => dataSource.searchProducts(query);

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) => dataSource.getProductsByCategory(category);
}