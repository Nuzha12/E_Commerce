import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final bool loading;
  final String query;
  final String category;

  const ProductState({
    this.products = const [],
    this.selectedProduct,
    this.loading = false,
    this.query = '',
    this.category = 'All',
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    ProductEntity? selectedProduct,
    bool? loading,
    String? query,
    String? category,
    bool clearSelected = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProduct: clearSelected ? null : selectedProduct ?? this.selectedProduct,
      loading: loading ?? this.loading,
      query: query ?? this.query,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [products, selectedProduct, loading, query, category];
}

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductEvent {
  final String query;
  final String category;

  const ProductsLoaded({
    this.query = '',
    this.category = 'All',
  });

  @override
  List<Object?> get props => [query, category];
}

class ProductLoadedById extends ProductEvent {
  final int id;

  const ProductLoadedById(this.id);

  @override
  List<Object?> get props => [id];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SearchProductsUseCase searchProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductBloc({
    required this.getProductByIdUseCase,
    required this.searchProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(const ProductState()) {
    on<ProductsLoaded>(_onProductsLoaded);
    on<ProductLoadedById>(_onProductLoadedById);
  }

  Future<void> _onProductsLoaded(ProductsLoaded event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      loading: true,
      query: event.query,
      category: event.category,
      clearSelected: true,
    ));

    List<ProductEntity> products;

    if (event.query.trim().isNotEmpty) {
      products = await searchProductsUseCase(event.query);
      if (event.category != 'All') {
        products = products.where((e) => e.category.toLowerCase() == event.category.toLowerCase()).toList();
      }
    } else {
      products = await getProductsByCategoryUseCase(event.category);
    }

    emit(state.copyWith(products: products, loading: false));
  }

  Future<void> _onProductLoadedById(ProductLoadedById event, Emitter<ProductState> emit) async {
    emit(state.copyWith(loading: true));
    final product = await getProductByIdUseCase(event.id);
    emit(state.copyWith(selectedProduct: product, loading: false));
  }
}